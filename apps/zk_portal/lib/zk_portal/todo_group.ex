defmodule ZkPortal.TodoGroup do
  use Ecto.Schema

  import Ecto.Changeset

  schema "todo_groups" do
    field :name, :string, null: false, size: 100, default: "Nowa kategoria"
    field :order, :integer, null: false
    field :is_archived, :boolean, null: false, default: false

    has_many :todo_items, ZkPortal.TodoItem

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:name, :order, :is_archived])
      |> validate_length(:name, max: 100)
      |> validate_number(:order, greater_than: 0)
  end
end