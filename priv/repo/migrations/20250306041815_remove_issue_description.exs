defmodule Ajisai.Repo.Migrations.RemoveIssueDescription do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      remove :description
    end
  end
end
