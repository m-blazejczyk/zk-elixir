defmodule ZkPortalWeb.BannerView do
  use ZkPortalWeb, :view

  def render("banners.all.json", %{banners: banners}) do
    Enum.map(banners, &banner_json/1)
  end
  def render("banner.new.json", %{banner: banner}) do
    banner_json(banner)
  end

  defp banner_json(banner) do
    Map.merge(
      %{
        id: banner.id,
        isSilent: banner.is_silent,
        startDate: banner.start_date,
        endDate: banner.end_date,
        url: banner.url,
        weight: banner.weight
      },
      image_json(banner.image)
    )
  end

  defp image_json(%ZkPortal.Image{} = image) do
    %{
      imageUrl: image.file,
      imageHeight: image.height,
      imageWidth: image.width
    }
  end
  defp image_json(_anything) do
    %{
      imageUrl: nil,
      imageHeight: nil,
      imageWidth: nil
    }
  end
end