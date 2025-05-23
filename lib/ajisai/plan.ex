defmodule Ajisai.Plan do
  @moduledoc """
  The Plan context.
  """

  import Ecto.Query, warn: false

  alias Ajisai.Plan.Issue
  alias Ajisai.Repo

  @doc """
  Returns the list of issues.

  ## Examples

      iex> list_issues()
      [%Issue{}, ...]

  """
  def list_issues do
    Repo.all(Issue)
  end

  @doc """
  Returns active issues.
  """
  def active_issues_by_user(user) do
    Issue.Query.active()
    |> Issue.Query.for_user(user)
    |> Repo.all()
  end

  def closed_issues_by_user(user) do
    Issue.Query.closed()
    |> Issue.Query.for_user(user)
    |> Repo.all()
  end

  @doc """
  Gets a single issue.

  Raises `Ecto.NoResultsError` if the Issue does not exist.

  ## Examples

      iex> get_issue!("isspCG1HBiy3jSd1DhQMryW6h")
      %Issue{}

      iex> get_issue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue!(issue_id), do: Repo.get!(Issue, issue_id)

  @doc """
  Creates a issue.

  ## Examples

      iex> create_issue(%{field: value})
      {:ok, %Issue{}}

      iex> create_issue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(attrs \\ %{}) do
    %Issue{}
    |> Issue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a issue.

  ## Examples

      iex> update_issue(issue, %{field: new_value})
      {:ok, %Issue{}}

      iex> update_issue(issue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue(%Issue{} = issue, attrs) do
    issue
    |> Issue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Activate a issue.
  """
  def activate_issue(%Issue{} = issue) do
    issue
    |> Issue.changeset(%{status: :active})
    |> Repo.update()
  end

  def close_issue(%Issue{} = issue) do
    issue
    |> Issue.changeset(%{status: :closed})
    |> Repo.update()
  end

  @doc """
  Deletes a issue.

  ## Examples

      iex> delete_issue(issue)
      {:ok, %Issue{}}

      iex> delete_issue(issue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_issue(%Issue{} = issue) do
    Repo.delete(issue)
  end

  @doc """
  Delete all closed issues with given user.
  """
  def delete_closed_issues_by_user(user) do
    {_count, issues} =
      Issue.Query.closed() |> Issue.Query.for_user(user) |> select([i], i) |> Repo.delete_all()

    issues
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue changes.

  ## Examples

      iex> change_issue(issue)
      %Ecto.Changeset{data: %Issue{}}

  """
  def change_issue(%Issue{} = issue, attrs \\ %{}) do
    Issue.changeset(issue, attrs)
  end
end
