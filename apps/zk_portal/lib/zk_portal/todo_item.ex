defmodule ZkPortal.TodoItem do
  use Ecto.Schema

  import Ecto.Changeset

  schema "todo_items" do
    field :name, :string, null: false, size: 200, default: "Nowa rzecz"
    field :priority, :integer, null: false, default: 1
    field :status, :integer, null: false, default: 0
    field :order, :integer, null: false

    belongs_to :todo_group, ZkPortal.TodoGroup

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:name, :priority, :status, :order, :todo_group_id])
      |> validate_length(:name, max: 200)
      |> validate_number(:priority, greater_than_or_equal_to: 0, less_than_or_equal_to: 3)
      |> validate_number(:status, greater_than_or_equal_to: 0, less_than_or_equal_to: 3)
      |> validate_number(:order, greater_than: 0)
  end

  def priority_text(0), do: "Dzień-dwa"
  def priority_text(1), do: "Tydzień"
  def priority_text(2), do: "Dwa-trzy tygodnie"
  def priority_text(3), do: "Kiedyś"
  def priority_text(_), do: ""

  def status_text(0), do: "Niezaczęte"
  def status_text(1), do: "Zaczęte"
  def status_text(2), do: "Skończone"
  def status_text(3), do: "Anulowane"
  def status_text(_), do: ""
end