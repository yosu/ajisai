defmodule Ajisai.Plan.Issue.Id do
  use Ecto.Type

  def type, do: :string
  def cast(id), do: {:ok, id}
  def dump(id), do: {:ok, id}
  def load(id), do: {:ok, id}

  def autogenerate, do: "iss" <> ShortUUID.generate()
end
