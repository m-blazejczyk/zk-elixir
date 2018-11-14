defmodule ZkPortal.Banner do
  use Ecto.Schema

  import Ecto.Changeset

  schema "banners" do
    field :is_silent, :boolean, null: false, default: false
    field :start_date, :date
    field :end_date, :date
    field :url, :string, size: 1024
    field :weight, :integer, null: false, default: 10
    belongs_to :image, ZkPortal.Image
    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:is_silent, :start_date, :end_date, :url, :weight, :image_id])
      |> validate_length(:url, max: 1024)
      |> validate_number(:weight, greater_than: 0)
  end
end