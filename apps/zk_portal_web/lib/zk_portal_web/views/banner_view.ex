defmodule ZkPortalWeb.BannerView do
  use ZkPortalWeb, :view

  def render("banners.all.json", %{banners: banners}) do
    Enum.map(banners, &banner_json/1)
  end
  def render("banner.new.json", %{banner: banner}) do
    banner_json(banner)
  end

  def banner_json(banner) do
    %{
      id: banner.id,
      isSilent: banner.is_silent,
      startDate: banner.start_date,
      endDate: banner.end_date,
      url: banner.url,
      weight: banner.weight,
      imageUrl: banner.image.file,
      imageHeight: banner.image.height,
      imageWidth: banner.image.width
    }
  end
end