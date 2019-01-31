defmodule ZkPortal.Image do
  use Ecto.Schema

  import Ecto.Changeset

  schema "images" do
    field :file, :string, null: false, size: 100
    field :width, :integer, null: false
    field :height, :integer, null: false

    has_one :banner, ZkPortal.Banner
    has_one :image_big, ZkPortal.Image
    has_one :image_medium, ZkPortal.Image
    has_one :image_small, ZkPortal.Image

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:file, :width, :height])
      |> validate_length(:file, max: 100)
      |> validate_number(:width, greater_than: 0, less_than: 2000)
      |> validate_number(:height, greater_than: 0, less_than: 2000)
  end

  def full_path(%ZkPortal.Image{file: file}), do: upload_root() <> file
  def full_path(file_str) when is_bitstring(file_str), do: upload_root() <> file_str
  def full_path(_), do: {:error, "Invalid argument to full_path"}

  defp upload_root(), do: System.get_env("ZK_UPLOAD")
end