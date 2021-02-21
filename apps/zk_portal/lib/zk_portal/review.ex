defmodule ZkPortal.Review do
  use Ecto.Schema

  import Ecto.Changeset

  schema "reviews" do
    field :title, :string, size: 200, null: false
    field :author, :string, size: 100, null: false
    field :pub_date, :string, size: 30, null: false
    field :comics_author, :string, size: 200, null: false
    field :comics_title, :string, size: 200, null: false
    field :publisher, :string, size: 80, null: false
    field :publisher_url, :string, size: 80, null: true
    field :review, :string, size: 2000, null: false
    field :info, :string, size: 500, null: false
    field :buy_urls, :string, size: 2000, null: false

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:title, :author, :pub_date, :comics_author, :comics_title,
                       :publisher, :publisher_url, :review, :info, :buy_urls])
      |> validate_length(:title, max: 200)
      |> validate_length(:author, max: 100)
      |> validate_length(:pub_date, max: 30)
      |> validate_length(:comics_author, max: 200)
      |> validate_length(:comics_title, max: 200)
      |> validate_length(:publisher, max: 80)
      |> validate_length(:publisher_url, max: 80)
      |> validate_length(:review, max: 2000)
      |> validate_length(:info, max: 500)
      |> validate_length(:buy_urls, max: 2000)
  end
end