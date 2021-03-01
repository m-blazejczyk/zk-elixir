defmodule ZkPortal.Repo.Migrations.ReviewsMakeFieldsNull do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      modify :info, :string, size: 500, null: true
      modify :buy_urls, :string, size: 2000, null: true
    end
  end
end
