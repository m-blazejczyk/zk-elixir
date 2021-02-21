defmodule ZkPortal.Repo.Migrations.AddReviewsPageName do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      add :page_name, :string, null: false, size: 50
    end
  end
end
