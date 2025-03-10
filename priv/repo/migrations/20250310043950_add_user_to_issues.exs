defmodule Ajisai.Repo.Migrations.AddUserToIssues do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add(:user_id, references(:users, type: :string, on_delete: :delete_all))
    end
  end
end
