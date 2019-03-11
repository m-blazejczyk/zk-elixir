defmodule ZkPortalWeb.BannerView do
  use ZkPortalWeb, :view

  alias ZkPortalWeb.ImageView;

  def render("banners.all.json", %{banners: banners}) do
    Enum.map(banners, &ImageView.as_json/1)
  end
  def render("banner.new.json", %{banner: banner}) do
    banner_json(banner)
  end
  def render("upload.success.json", %{image: image}) do
    ImageView.as_json(image)
  end

  defp banner_json(banner) do
    %{
      id: banner.id,
      isSilent: banner.is_silent,
      startDate: banner.start_date,
      endDate: banner.end_date,
      url: banner.url,
      weight: banner.weight,
      image: ImageView.as_json(banner.image)
    }
  end
end