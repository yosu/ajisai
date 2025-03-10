defmodule Ajisai.PlanFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ajisai.Plan` context.
  """
  import Ajisai.AccountFixtures

  @doc """
  Generate a issue.
  """
  def issue_fixture(attrs \\ %{}) do
    {:ok, issue} =
      attrs
      |> Enum.into(%{
        issue_id: Ajisai.Id.autogenerate(%{prefix: "iss_"}),
        title: "some title",
        status: :active,
        user_id: user_fixture().id
      })
      |> Ajisai.Plan.create_issue()

    issue
  end
end
