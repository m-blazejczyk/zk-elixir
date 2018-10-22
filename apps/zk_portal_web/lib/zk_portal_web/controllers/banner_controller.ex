defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller

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
            conn |> put_status(:bad_request)
        end        
      :error ->
        conn |> put_status(:bad_request)
    end
  end
end