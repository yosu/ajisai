defmodule Ajisai.PlanTest do
  use Ajisai.DataCase

  alias Ajisai.Plan

  describe "issues" do
    alias Ajisai.Plan.Issue

    import Ajisai.PlanFixtures

    @invalid_attrs %{title: nil}

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Plan.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Plan.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      valid_attrs = %{title: "some title", status: :active}

      assert {:ok, %Issue{} = issue} = Plan.create_issue(valid_attrs)
      assert issue.title == "some title"
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plan.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Issue{} = issue} = Plan.update_issue(issue, update_attrs)
      assert issue.title == "some updated title"
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Plan.update_issue(issue, @invalid_attrs)
      assert issue == Plan.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Plan.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Plan.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Plan.change_issue(issue)
    end
  end
end
