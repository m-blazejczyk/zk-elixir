defmodule ZkPortal.IssueLang do
  use Ecto.Schema

  import Ecto.Changeset

  schema "issues_lang" do

    field :is_published, :boolean, null: false, default: false
    field :pub_date, :string, size: 30
    field :topic, :string, size: 100
    field :editorial, :string, size: 2000
    field :editorial_sig, :string, size: 200

    has_one :issue_pl, ZkPortal.Issue
    has_one :issue_en, ZkPortal.Issue

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
      |> cast(params, [:pub_date, :topic, :editorial, :editorial_sig])
      |> validate_length(:pub_date, max: 30)
      |> validate_length(:topic, max: 100)
      |> validate_length(:editorial, max: 2000)
      |> validate_length(:editorial_sig, max: 200)              
  end
end
