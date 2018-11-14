defmodule ZkPortal.Image do
  use Ecto.Schema

  import Ecto.Changeset

  schema "images" do
    field :file, :string, null: false, size: 100
    field :width, :integer, null: false
    field :height, :integer, null: false
    has_one :banner, ZkPortal.Banner
    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:file, :width, :height])
      |> validate_length(:file, max: 100)
      |> validate_number(:width, greater_than: 0, less_than: 2000)
      |> validate_number(:height, greater_than: 0, less_than: 2000)
  end

  def full_path(image_or_path) do
    case image_or_path do
      %ZkPortal.Image{file: file} ->
        "static/upload/" <> file
      file_str when is_bitstring(file_str) ->
        "static/upload/" <> file_str
      _ ->
        {:error, "Invalid argument to full_path"}
    end
  end
end