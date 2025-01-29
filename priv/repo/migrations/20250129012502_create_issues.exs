defmodule Ajisai.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :title, :string, null: false
      add :description, :text, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
