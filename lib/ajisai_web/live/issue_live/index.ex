defmodule AjisaiWeb.IssueLive.Index do
  use AjisaiWeb, :live_view

  alias Ajisai.Plan
  alias Ajisai.Plan.Issue
  alias AjisaiWeb.IssueLive.IssueList
  alias AjisaiWeb.IssueLive.ClosedIssueList

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {
      :ok,
      # 複数のstreamで同じDOM idを使うとDOMのトラッキングがうまくいかなくなるため、
      # （片方から消してもう片方から消すということができない）closedとactiveとで
      # DOM idの系列を分けるようにする。
      socket
      |> stream_configure(:closed_issues, dom_id: &"closed-#{&1.id}")
      |> stream(:issues, Plan.active_issues_by_user(user))
      |> stream(:closed_issues, Plan.closed_issues_by_user(user))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "編集")
    |> assign(:issue, Plan.get_issue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "新規作成")
    |> assign(:issue, %Issue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "イシュー一覧")
    |> assign(:issue, nil)
  end

  @impl true
  def handle_info({AjisaiWeb.IssueLive.FormComponent, {:saved, issue}}, socket) do
    {:noreply, stream_insert(socket, :issues, issue)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    issue = Plan.get_issue!(id)
    {:ok, _} = Plan.delete_issue(issue)

    {:noreply, stream_delete(socket, :issues, issue)}
  end

  def handle_event("close", %{"id" => id}, socket) do
    issue = Plan.get_issue!(id)
    {:ok, closed_issue} = Plan.close_issue(issue)

    {:noreply,
     socket
     |> stream_delete(:issues, issue)
     |> stream_insert(:closed_issues, closed_issue)}
  end

  def handle_event("activate", %{"id" => id}, socket) do
    closed_issue = Plan.get_issue!(id)
    {:ok, issue} = Plan.activate_issue(closed_issue)

    {:noreply,
     socket
     |> stream_delete(:closed_issues, closed_issue)
     |> stream_insert(:issues, issue)}
  end

  def handle_event("delete_closed", _value, socket) do
    user = socket.assigns.current_user
    deleted_issues = Plan.delete_closed_issues_by_user(user)

    {:noreply,
     deleted_issues
     |> Enum.reduce(socket, fn deleted_issue, socket ->
       stream_delete(socket, :closed_issues, deleted_issue)
     end)}
  end
end
