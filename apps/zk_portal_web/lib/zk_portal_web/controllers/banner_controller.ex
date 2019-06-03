defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  import Plug.Conn

  def all(conn, _params) do
    banners = ZkPortal.list_banners
    Logger.info "Returning all #{length(banners)} banner(s) to user #{conn.assigns.user.userName}"
    render conn, "banners.all.json", banners: banners
  end

  def new(conn, _params) do
    banner = ZkPortal.new_banner
    Logger.info "User #{conn.assigns.user.userName} created a new banner"
    render conn, "banner.new.json", banner: banner
  end

  # See https://hexdocs.pm/plug/Plug.Conn.Status.html
  def delete(conn, %{"id" => id}) do
    Logger.info "User #{conn.assigns.user.userName} tries deleting the banner with id #{id}..."
    case Integer.parse(id) do
      {iid, _} ->
        case ZkPortal.delete_banner(%ZkPortal.Banner{id: iid}) do
          {:ok, _} ->
            Logger.info "...and succeeds"
            conn |> send_resp(:ok, "")
          {:error, err} ->
            Logger.error "...and fails due to #{inspect err}"
            conn |> send_resp(:bad_request, "")
        end        
      :error ->
        Logger.error "...and fails due to invalid id"
        conn |> send_resp(:bad_request, "")
    end
  end
  def delete(conn, _) do
    Logger.info "User #{conn.assigns.user.userName} tries deleting a banner but fails due to id not provided"
    conn |> send_resp(:bad_request, "")
  end

  # See https://github.com/vic/params
  defparams update_params %{
    id!: :integer,     # required
    is_silent: :boolean,  # accepts lowercase values true and false
    start_date: :date,
    endDate: :date,
    url: :string,
    weight: :integer
  }

  def update(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} tries updating a banner with #{inspect params}..."
    changeset = update_params(params)
    if changeset.valid? do
      validated_params = Params.to_map changeset
      banner = %ZkPortal.Banner{
        id: validated_params.id,
        is_silent: fix_is_silent(validated_params)
      }
      case ZkPortal.update_banner(banner, validated_params) do
        {:ok, _} ->
          Logger.info "...and succeeds"
          conn |> send_resp(:ok, "")
        {:error, err} ->
          Logger.error "...and fails due to #{inspect err}"
          conn |> send_resp(:bad_request, "")
      end
    else
      Logger.error "...and fails in validation phase"
      conn |> send_resp(:bad_request, "")
    end
  end

  # This function is needed so that turning off is_silent actually works.
  # Without it, considering that is_silent is set to false by default when a Banner is created,
  # setting it to false by the web client is ignored by the changeset mechanism.
  defp fix_is_silent(%{"is_silent" => "true"}), do: "false"
  defp fix_is_silent(%{"is_silent" => "false"}), do: "true"
  defp fix_is_silent(params), do: "false"

  # %{
  #   "SelectedFile" => %Plug.Upload{
  #     content_type: "image/png",
  #     filename: "test-png-200.png",
  #     path: "/var/folders/yv/crg89_ss0j95kdgny8cn2_2h0000gn/T//plug-1541/multipart-1541902317-524669662203582-1"
  #   },
  #   "id" => "1"
  # }
  def upload(conn, %{"id" => id, "SelectedFile" => upload}) do
    Logger.info "User #{conn.assigns.user.userName} tries uploading an image for banner with id #{id}..."
    with %Plug.Upload{content_type: content_type, path: path} <- upload,
         {:ok, file_type} <- verify_file_type(content_type),
         {iid, _} <- Integer.parse(id),
         fwf <- random_filename_with_folder(file_type),
         full_path <- ZkPortal.Image.full_path(fwf),
         :ok <- File.rename(path, full_path),
         img <- resize_image(full_path, 200, 10000),
         img_db <- %ZkPortal.Image{file: fwf, width: img.width, height: img.height},
         :ok <- ZkPortal.update_image_in_banner(iid, img_db)
    do
      Logger.info "...and succeeds; file = #{fwf}"
      render conn, "upload.success.json", image: img_db
    else
      # Problem with File.rename or database operations.
      {:error, error} ->
        Logger.error "...and fails due to #{inspect error}"
        conn |> send_resp(:internal_server_error, "")
      # All other problems.
      anything_else ->
        Logger.error "...and fails due to #{inspect anything_else}"
        conn |> send_resp(:bad_request, "")
    end
  end
  def upload(conn, _) do
    Logger.info "User #{conn.assigns.user.userName} tries uploading an image for a banner but the request is invalid"
    conn |> send_resp(:bad_request, "")
  end

  defp verify_file_type(content_type) do
    cond do
      content_type == "image/png" -> {:ok, :png}
      content_type == "image/jpeg" -> {:ok, :jpg}
      true -> :error
    end
  end

  defp random_filename_with_folder(file_type) do
    <<folder_byte, filename_bytes :: binary>> = :crypto.strong_rand_bytes(20)
    filename = filename_bytes |> Base.url_encode64(padding: false)
    folder = folder_byte |> div(16) |> Integer.to_string(16) |> String.downcase
    folder <> "/" <> filename <> (if file_type == :png, do: ".png", else: ".jpg")
  end

  # Return Mogrify.Image with 'width' and 'height' set.
  def resize_image(imagePath, width, height) do
    Mogrify.open(imagePath)
    |> Mogrify.resize_to_limit(~s(#{width}x#{height}))
    |> Mogrify.save(in_place: true)
    |> Mogrify.verbose()
  end
end