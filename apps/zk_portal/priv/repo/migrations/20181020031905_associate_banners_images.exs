defmodule ZkPortal.Repo.Migrations.AssociateBannersImages do
  use Ecto.Migration

  def change do
    alter table(:banners) do
      modify :weight, :integer, null: false, default: 10
      modify :is_silent, :boolean, null: false, default: false
      modify :url, :varchar, size: 1024
      add :image_id, references(:images), null: true
    end

    alter table(:images) do
      modify :file, :string, null: false, size: 40
      modify :width, :integer, null: false
      modify :height, :integer, null: false
    end
  end
end
