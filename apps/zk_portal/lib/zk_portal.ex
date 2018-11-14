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

  def update_image_in_banner(banner_id, %Image{} = image) do
    with banner when banner !== nil <- @repo.get(Banner, banner_id),
         old_img_id <- banner.image_id,
         {:ok, new_img} <- @repo.insert(image),
         {:ok, _} <- update_banner(banner, %{image_id: new_img.id}),
         {:ok, _} <- @repo.delete(%Image{id: old_img_id})
    do
      :ok
    else
      nil -> {:error, "Invalid banner id"}
      {:error, error} -> {:error, error}
    end
  end
end
