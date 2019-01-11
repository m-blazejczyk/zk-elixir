defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  import Plug.Conn;

  def all(conn, _params) do
    banners = ZkPortal.list_banners
    render conn, "banners.all.json", banners: banners
  end

  def new(conn, _params) do
    banner = ZkPortal.new_banner
    render conn, "banner.new.json", banner: banner
  end

  # See https://hexdocs.pm/plug/Plug.Conn.Status.html
  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {iid, _} ->
        case ZkPortal.delete_banner(%ZkPortal.Banner{id: iid}) do
          {:ok, _} ->
            conn |> send_resp(:ok, "")
          {:error, _} ->
            conn |> send_resp(:bad_request, "")
        end        
      :error ->
        conn |> send_resp(:bad_request, "")
    end
  end
  def delete(conn, _) do
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
    changeset = update_params(params)
    if changeset.valid? do
      validated_params = Params.to_map changeset
      case ZkPortal.update_banner(%ZkPortal.Banner{id: validated_params.id}, validated_params) do
        {:ok, _} ->
          conn |> send_resp(:ok, "")
        {:error, _} ->
          conn |> send_resp(:bad_request, "")
      end
    else
      conn |> send_resp(:bad_request, "")
    end
  end

  # %{
  #   "SelectedFile" => %Plug.Upload{
  #     content_type: "image/png",
  #     filename: "test-png-200.png",
  #     path: "/var/folders/yv/crg89_ss0j95kdgny8cn2_2h0000gn/T//plug-1541/multipart-1541902317-524669662203582-1"
  #   },
  #   "id" => "1"
  # }
  def upload(conn, %{"id" => id, "SelectedFile" => upload}) do
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
      render conn, "upload.success.json", image: img_db
    else
      # Problem with File.rename or database operations.
      {:error, error} ->
        IO.inspect(error, label: "Upload problem (DB or File.rename)")
        conn |> send_resp(:internal_server_error, "")
      # All other problems.
      anything_else ->
        IO.inspect anything_else, label: "Upload problem (other)"
        conn |> send_resp(:bad_request, "")
    end
  end
  def upload(conn, _) do
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