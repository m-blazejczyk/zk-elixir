defmodule ZkPortal.Review do
  use Ecto.Schema

  import Ecto.Changeset

  schema "reviews" do
    field :page_name, :string, size: 50, null: false
    field :title, :string, size: 200, null: false
    field :author, :string, size: 100, null: false
    field :pub_date, :string, size: 30, null: false

    field :review, :string, size: 2000, null: false

    # This de-normalized design may seem surprising.
    # The main reason is that we want to achieve greater flexibility;
    # we want to be able to mix and match freely.
    field :comics_author_1, :string, size: 200, null: false
    field :comics_title_1, :string, size: 200, null: false
    field :publisher_1, :string, size: 600, null: false
    field :info_1, :string, size: 500, null: true
    field :buy_urls_1, :string, size: 2000, null: true

    field :comics_author_2, :string, size: 200, null: true
    field :comics_title_2, :string, size: 200, null: true
    field :publisher_2, :string, size: 600, null: true
    field :info_2, :string, size: 500, null: true
    field :buy_urls_2, :string, size: 2000, null: true

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:page_name, :title, :author, :pub_date, :review,
                       :comics_author_1, :comics_title_1, :publisher_1, :info_1, :buy_urls_1,
                       :comics_author_2, :comics_title_2, :publisher_2, :info_2, :buy_urls_2])
      |> validate_required([:page_name, :title, :author, :pub_date, :review,
                           :comics_author_1, :comics_title_1, :publisher_1])
      |> validate_length(:page_name, max: 50)
      |> validate_length(:title, max: 200)
      |> validate_length(:author, max: 100)
      |> validate_length(:pub_date, max: 30)
      |> validate_length(:review, max: 2000)
      |> validate_length(:comics_author_1, max: 200)
      |> validate_length(:comics_title_1, max: 200)
      |> validate_length(:publisher_1, max: 600)
      |> validate_length(:info_1, max: 500)
      |> validate_length(:buy_urls_1, max: 2000)
      |> validate_length(:comics_author_2, max: 200)
      |> validate_length(:comics_title_2, max: 200)
      |> validate_length(:publisher_2, max: 600)
      |> validate_length(:info_2, max: 500)
      |> validate_length(:buy_urls_2, max: 2000)
  end
end