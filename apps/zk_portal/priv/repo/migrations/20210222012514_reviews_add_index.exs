defmodule ZkPortal.Repo.Migrations.ReviewsAddIndex do
  use Ecto.Migration

  def change do
    create(
      unique_index(
        :reviews,
        [:page_name],
        name: :page_name_index
      )
    )
  end
end
