defmodule ZkPortal.Issue do
  use Ecto.Schema

  import Ecto.Changeset

  schema "issues" do
    field :availability, :integer, null: false, default: 1
    field :price, :string, null: false, size: 10, default: "??"

    belongs_to :issue_pl, ZkPortal.IssueLang, foreign_key: :issue_pl_id
    belongs_to :issue_en, ZkPortal.IssueLang, foreign_key: :issue_en_id
    
    belongs_to :image_big, ZkPortal.Image, foreign_key: :image_big_id
    belongs_to :image_medium, ZkPortal.Image, foreign_key: :image_medium_id
    belongs_to :image_small, ZkPortal.Image, foreign_key: :image_small_id

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:availability, :price, :issue_pl_id, :issue_en_id,
                       :image_big_id, :image_medium_id, :image_small_id])
      |> validate_length(:price, max: 10)
      |> validate_number(:availability, greater_than: 0)
      |> validate_number(:availability, less_than: 5)
  end

  def availabilities() do
    %{1 => "W przygotowaniu",
      2 => "Dostępny",
      3 => "Dostępny dodruk",
      4 => "Nakład wyczerpany"
    }
  end
end
