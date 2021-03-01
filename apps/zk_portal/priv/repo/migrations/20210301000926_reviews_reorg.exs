defmodule ZkPortal.Repo.Migrations.ReviewsReorg do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      remove :comics_author
      remove :comics_title
      remove :publisher
      remove :publisher_url
      remove :info
      remove :buy_urls

      add :comics_author_1, :string, size: 200, null: false
      add :comics_title_1, :string, size: 200, null: false
      add :publisher_1, :string, size: 80, null: false
      add :publisher_url_1, :string, size: 80, null: true
      add :info_1, :string, size: 500, null: false
      add :buy_urls_1, :string, size: 2000, null: false

      add :comics_author_2, :string, size: 200, null: true
      add :comics_title_2, :string, size: 200, null: true
      add :publisher_2, :string, size: 80, null: true
      add :publisher_url_2, :string, size: 80, null: true
      add :info_2, :string, size: 500, null: true
      add :buy_urls_2, :string, size: 2000, null: true
    end
  end
end
