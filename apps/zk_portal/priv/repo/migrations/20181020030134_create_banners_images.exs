defmodule ZkPortal.Repo.Migrations.CreateBannersImages do
  use Ecto.Migration

  def change do
    create table(:banners) do
      add :is_silent, :boolean
      add :start_date, :date
      add :end_date, :date
      add :url, :string
      add :weight, :integer
      #add :image_id, references(:images)
      timestamps()
    end

    create table(:images) do
      add :file, :string
      add :width, :integer
      add :height, :integer
      timestamps()
    end
  end
end
