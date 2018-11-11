defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller
  use Params

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
         {iid, _} <- Integer.parse(id)
    do
      conn |> send_resp(:ok, "")
    else
      _ -> conn |> send_resp(:bad_request, "")
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
end