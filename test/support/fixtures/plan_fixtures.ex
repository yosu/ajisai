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
        issue_id: Ajisai.Id.autogenerate(%{prefix: "iss_"}),
        title: "some title",
        status: :active
      })
      |> Ajisai.Plan.create_issue()

    issue
  end
end
