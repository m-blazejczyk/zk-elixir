defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller

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
            Plug.Conn.send_resp(conn, :ok, "")
          {:error, _} ->
            Plug.Conn.put_status(conn, :bad_request)
        end        
      :error ->
        Plug.Conn.put_status(conn, :bad_request)
    end
  end
end