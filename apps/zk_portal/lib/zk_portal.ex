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
  alias ZkPortal.Issue
  alias ZkPortal.IssueLang
  alias ZkPortal.TodoGroup

  @repo ZkPortal.Repo

  ###################################################################
  # BANNERS
  ###################################################################
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
         old_img <- get_image(banner.image_id),
         {:ok, new_img} <- @repo.insert(raw_new_img),
         {:ok, _} <- update_banner(banner, %{image_id: new_img.id})
    do
      # Delete the old image from DB and file but only if it existed.
      if old_img do
        File.rm(Image.full_path(old_img))
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

  # Function necessary to prevent ArgumentError when image_id is nil.
  defp get_image(nil), do: nil
  defp get_image(image_id), do: @repo.get(Image, image_id)

  ###################################################################
  # ISSUES
  ###################################################################
  def list_issues do
    @repo.all(from Issue, preload: [:issue_pl, :issue_en, :image_small])
  end

  def new_issue do
    with {:ok, lang_pl} <- @repo.insert(%IssueLang{}),
         {:ok, lang_en} <- @repo.insert(%IssueLang{})
    do
      issue = %Issue{issue_pl: lang_pl, issue_en: lang_en}
      @repo.insert!(issue)
    else
      {:error, error} -> {:error, error}
    end
  end

  # This is the least important feature for now.
  # We need code that will only delete unpublished issues.
  def delete_issue(_issue), do: {:error, "not implemented"}
  
  def update_issue(%Issue{} = issue, updates) do
    issue
      |> Issue.changeset(updates)
      |> @repo.update()
  end

  def update_issue_lang(%IssueLang{} = issue_lang, updates) do
    issue_lang
      |> IssueLang.changeset(updates)
      |> @repo.update()
  end

  ###################################################################
  # TODOS
  ###################################################################
  def list_todos do
    q = from g in TodoGroup,
      join: i in assoc(g, :todo_items),
      order_by: [g.order], 
      where: g.is_archived == false,
      preload: [todo_items: i]
    @repo.all(q)
  end

end
