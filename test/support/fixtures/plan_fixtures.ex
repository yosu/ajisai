defmodule Ajisai.PlanFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ajisai.Plan` context.
  """

  @doc """
  Generate a issue.
  """
  def issue_fixture(attrs \\ %{}) do
    {:ok, issue} =
      attrs
      |> Enum.into(%{
        description: "some description",
        issue_id: Ajisai.Id.autogenerate(%{prefix: "iss_"}),
        title: "some title"
      })
      |> Ajisai.Plan.create_issue()

    issue
  end
end
