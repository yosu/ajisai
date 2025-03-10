defmodule Ajisai.Plan.Issue do
  use Ecto.Schema
  import Ecto.Changeset
  import Ajisai.Validateion

  @primary_key {:id, Ajisai.Id, autogenerate: true, prefix: "iss_"}
  schema "issues" do
    field :title, :string, default: ""
    field :status, Ecto.Enum, values: [:active, :closed], default: :active
    belongs_to :user, Ajisai.Account.User, type: :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :status, :user_id])
    |> validate_not_nil([:title, :status])
    |> validate_required([:user_id])
  end
end
