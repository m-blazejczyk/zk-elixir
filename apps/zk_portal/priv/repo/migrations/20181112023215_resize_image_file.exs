defmodule ZkPortal.Repo.Migrations.ResizeImageFile do
  use Ecto.Migration

  def change do
    alter table(:images) do
      modify :file, :string, null: false, size: 100
    end
  end
end
