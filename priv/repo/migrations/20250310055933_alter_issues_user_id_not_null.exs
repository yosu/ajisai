defmodule Ajisai.Repo.Migrations.AlterIssuesUserIdNotNull do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      modify :user_id, :string, null: false
    end
  end
end
