defmodule ZkPortal.Repo.Migrations.AddBasicTodos do
  use Ecto.Migration

  def change do
    create table(:todo_groups) do
      add :name, :string, null: false, size: 100, default: "Nowa kategoria"
      add :order, :integer, null: false
      add :is_archived, :boolean, null: false, default: false

      timestamps()
    end

    create table(:todo_items) do
      add :name, :string, null: false, size: 200, default: "Nowe zadanie"
      add :priority, :integer, null: false, default: 1
      add :status, :integer, null: false, default: 0
      add :order, :integer, null: false

      add :todo_group_id, references(:todo_groups), null: false

      timestamps()
    end
  end
end
