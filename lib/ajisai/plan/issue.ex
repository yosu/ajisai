defmodule Ajisai.Plan.Issue do
  use Ecto.Schema
  import Ecto.Changeset
  import Ajisai.Validateion

  @primary_key {:id, Ajisai.Plan.Issue.Id, autogenerate: true}
  schema "issues" do
    field :title, :string, default: ""
    field :description, :string, default: ""

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :description])
    |> validate_not_nil([:title, :description])
  end
end
