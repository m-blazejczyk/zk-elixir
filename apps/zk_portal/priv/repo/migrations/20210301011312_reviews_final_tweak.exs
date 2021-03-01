defmodule ZkPortal.Repo.Migrations.ReviewsFinalTweak do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      modify :info_1, :string, size: 500, null: true
      modify :buy_urls_1, :string, size: 2000, null: true

      modify :publisher_1, :string, size: 600, null: false
      remove :publisher_url_1

      modify :publisher_2, :string, size: 600, null: true
      remove :publisher_url_2
    end
  end
end
