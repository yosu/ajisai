defmodule Ajisai.Plan.Issue.Query do
  import Ecto.Query

  def base, do: Ajisai.Plan.Issue

  def active(query \\ base()) do
    query
    |> where([i], i.status == :active)
  end

  def closed(query \\ base()) do
    query
    |> where([i], i.status == :closed)
  end

  def for_user(query \\ base(), user) do
    query
    |> where([i], i.user_id == ^user.id)
  end
end
