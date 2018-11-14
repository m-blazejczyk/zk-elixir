defmodule ZkPortal do
  @moduledoc """
  ZkPortal keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import Ecto.Query

  alias ZkPortal.Banner
  alias ZkPortal.Image

  @repo ZkPortal.Repo

  def list_banners do
    @repo.all(from Banner, preload: :image)
  end

  def new_banner do
    @repo.insert!(%Banner{})
  end

  def delete_banner(%Banner{} = banner), do: @repo.delete(banner)

  def update_banner(%Banner{} = banner, updates) do
    banner
      |> Banner.changeset(updates)
      |> @repo.update()
  end

  def update_image_in_banner(banner_id, %Image{} = raw_new_img) do
    with banner when banner !== nil <- @repo.get(Banner, banner_id),
         old_img <- @repo.get(Image, banner.image_id),
         {:ok, new_img} <- @repo.insert(raw_new_img),
         {:ok, _} <- update_banner(banner, %{image_id: new_img.id})
    do
      # Delete the old image from DB and file but only if it existed.
      if old_img do
        File.rm(Image.full_path(old_img.file))
        @repo.delete(old_img)
        :ok
      else
        :ok
      end
    else
      nil -> {:error, "Invalid banner id"}
      {:error, error} -> {:error, error}
    end
  end
end
