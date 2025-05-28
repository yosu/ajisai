defmodule AjisaiWeb.IssueLive.Index do
  @moduledoc false
  use AjisaiWeb, :live_view

  alias Ajisai.Plan
  alias Ajisai.Plan.Issue
  alias AjisaiWeb.Endpoint
  alias AjisaiWeb.IssueLive.ClosedIssueList
  alias AjisaiWeb.IssueLive.FormComponent
  alias AjisaiWeb.IssueLive.IssueList

  @issues_topic "issues_topic"

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    if connected?(socket) do
      Endpoint.subscribe(topic(socket))
    end

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

  defp topic(socket) do
    user = socket.assigns.current_user
    @issues_topic <> ":" <> user.id
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
  def handle_info({FormComponent, {:saved, issue}}, socket) do
    Endpoint.broadcast(topic(socket), "issue_saved", %{issue: issue})

    {:noreply, socket}
  end

  def handle_info(%{event: "issue_saved", payload: %{issue: issue}}, socket) do
    {:noreply, stream_insert(socket, :issues, issue)}
  end

  def handle_info(%{event: "issue_closed", payload: %{issue: issue, closed_issue: closed_issue}}, socket) do
    {:noreply,
     socket
     |> stream_delete(:issues, issue)
     |> stream_insert(:closed_issues, closed_issue)}
  end

  def handle_info(%{event: "issue_activated", payload: %{issue: issue, closed_issue: closed_issue}}, socket) do
    {:noreply,
     socket
     |> stream_delete(:closed_issues, closed_issue)
     |> stream_insert(:issues, issue)}
  end

  def handle_info(%{event: "issue_deleted", payload: %{deleted_issues: deleted_issues}}, socket) do
    {:noreply,
     Enum.reduce(deleted_issues, socket, fn deleted_issue, socket ->
       stream_delete(socket, :closed_issues, deleted_issue)
     end)}
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

    Endpoint.broadcast(topic(socket), "issue_closed", %{issue: issue, closed_issue: closed_issue})

    {:noreply, socket}
  end

  def handle_event("activate", %{"id" => id}, socket) do
    closed_issue = Plan.get_issue!(id)
    {:ok, issue} = Plan.activate_issue(closed_issue)

    Endpoint.broadcast(topic(socket), "issue_activated", %{issue: issue, closed_issue: closed_issue})

    {:noreply, socket}
  end

  def handle_event("delete_closed", _value, socket) do
    user = socket.assigns.current_user
    deleted_issues = Plan.delete_closed_issues_by_user(user)

    Endpoint.broadcast(topic(socket), "issue_deleted", %{deleted_issues: deleted_issues})

    {:noreply, socket}
  end
end
