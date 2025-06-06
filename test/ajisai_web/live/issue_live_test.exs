defmodule AjisaiWeb.IssueLiveTest do
  use AjisaiWeb.ConnCase

  import Ajisai.PlanFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}

  defp create_issue(%{user: user}) do
    issue = issue_fixture(%{user_id: user.id})
    %{issue: issue}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_issue]

    test "lists all issues", %{conn: conn, issue: issue} do
      {:ok, _index_live, html} = live(conn, ~p"/issues")

      assert html =~ "イシュー一覧"
      assert html =~ issue.title
    end

    test "saves new issue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("a[data-test=new]") |> render_click() =~
               "新規作成"

      assert_patch(index_live, ~p"/issues/new")

      assert index_live
             |> form("#issue-form", issue: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/issues")

      html = render(index_live)
      assert html =~ "作成に成功しました"
      assert html =~ "some title"
    end

    test "updates issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("#issues-#{issue.id} a[data-test=edit]") |> render_click() =~
               "編集"

      assert_patch(index_live, ~p"/issues/#{issue}/edit")

      assert index_live
             |> form("#issue-form", issue: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/issues")

      html = render(index_live)
      assert html =~ "更新に成功しました"
      assert html =~ "some updated title"
    end

    test "close issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("#issues-#{issue.id} a[data-test=close]") |> render_click()
      assert has_element?(index_live, "#closed-#{issue.id}")
    end
  end
end
