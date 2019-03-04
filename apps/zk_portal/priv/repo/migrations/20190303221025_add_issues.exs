defmodule ZkPortal.Repo.Migrations.AddIssues do
  use Ecto.Migration

  def change do
    create table(:issues_lang) do
      add :is_published, :boolean, null: false, default: false
      add :has_toc, :boolean, null: false, default: false
      add :pub_date, :string, null: true, size: 30
      add :topic, :string, null: true, size: 100
      add :editorial, :varchar, null: true, size: 2000
      add :editorial_sig, :string, null: true, size: 200

      timestamps()
    end

    create table(:issues) do
      add :availability, :integer, null: false, default: 1
      add :price, :string, null: false, size: 10, default: "??"
  
      add :issue_pl_id, references(:issues_lang), null: false
      add :issue_en_id, references(:issues_lang), null: false
      
      add :image_big_id, references(:images), null: true
      add :image_medium_id, references(:images), null: true
      add :image_small_id, references(:images), null: true

      timestamps()
    end
  end
end
