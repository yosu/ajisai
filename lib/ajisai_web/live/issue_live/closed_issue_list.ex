defmodule AjisaiWeb.IssueLive.ClosedIssueList do
  use AjisaiWeb, :component

  attr :issues, :list, required: true

  def issue_list(assigns) do
    ~H"""
    <ul id="closed-issues" phx-update="stream">
      <li id="closed-issues-menu" class="block only:hidden">
        <.button phx-click={JS.push("delete_closed")} color={:danger} class="ml-4">
          Clear closed
        </.button>
      </li>
      <.issue_item :for={{dom_id, issue} <- @issues} issue={issue} dom_id={dom_id} />
    </ul>
    """
  end

  attr :dom_id, :string, required: true
  attr :issue, Ajisai.Plan.Issue, required: true

  defp issue_item(assigns) do
    ~H"""
    <li id={@dom_id} class="mb-1">
      <.link phx-click={JS.push("activate", value: %{id: @issue.id}) |> hide("##{@dom_id}")}>
        <.icon name="hero-arrow-uturn-left" class="bg-blue-600" />
      </.link>
      <span class="line-through text-gray-500">{@issue.title}</span>
    </li>
    """
  end
end
