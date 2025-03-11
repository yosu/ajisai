defmodule Ajisai.Plan.Issue.Query do
  @moduledoc """
  A query module for Issue.
  """
  import Ecto.Query

  def base, do: Ajisai.Plan.Issue

  def active(query \\ base()) do
    where(query, [i], i.status == :active)
  end

  def closed(query \\ base()) do
    where(query, [i], i.status == :closed)
  end

  def for_user(query \\ base(), user) do
    where(query, [i], i.user_id == ^user.id)
  end
end
