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

  def delete(_conn, %{"id" => id}) do
    ZkPortal.delete_banner(%ZkPortal.Banner{id: id})
  end
end