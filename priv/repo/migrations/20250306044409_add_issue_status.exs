defmodule Ajisai.Repo.Migrations.AddIssueStatus do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :status, :string, null: false, default: "active"
    end
  end
end
