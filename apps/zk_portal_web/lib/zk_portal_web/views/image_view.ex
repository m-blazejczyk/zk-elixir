defmodule ZkPortalWeb.ImageView do

  def as_json(%ZkPortal.Image{} = image) do
    %{
      file: image.file,
      height: image.height,
      width: image.width
    }
  end
  def as_json(_anything) do
    nil
  end
end