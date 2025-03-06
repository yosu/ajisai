defmodule AjisaiWeb.IssueLive.Index do
  use AjisaiWeb, :live_view

  alias Ajisai.Plan
  alias Ajisai.Plan.Issue
  alias AjisaiWeb.IssueLive.IssueList
  alias AjisaiWeb.IssueLive.ClosedIssueList

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:issues, Plan.active_issues())
     |> stream(:closed_issues, Plan.closed_issues())}
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
end
