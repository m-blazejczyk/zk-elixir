defmodule ZkPortal.Repo.Migrations.AddReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :title, :string, size: 200, null: false
      add :author, :string, size: 100, null: false
      add :pub_date, :string, size: 30, null: false
      add :comics_author, :string, size: 200, null: false
      add :comics_title, :string, size: 200, null: false
      add :publisher, :string, size: 80, null: false
      add :publisher_url, :string, size: 80, null: true
      add :review, :string, size: 2000, null: false
      add :info, :string, size: 500, null: false
      add :buy_urls, :string, size: 2000, null: false

      timestamps()
    end
  end
end
