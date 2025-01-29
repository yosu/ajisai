defmodule AjisaiWeb.IssueLive.Index do
  use AjisaiWeb, :live_view

  alias Ajisai.Plan
  alias Ajisai.Plan.Issue

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:issues, Plan.list_issues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, Plan.get_issue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Issue")
    |> assign(:issue, %Issue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Issues")
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
