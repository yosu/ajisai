defmodule AjisaiWeb.IssueLive.ClosedIssueList do
  use AjisaiWeb, :component

  attr :issues, :list, required: true

  def issue_list(assigns) do
    ~H"""
    <ul id="issues" phx-update="stream">
      <.issue_item :for={{_id, issue} <- @issues} issue={issue} />
    </ul>
    """
  end

  attr :issue, Ajisai.Plan.Issue, required: true

  defp issue_item(assigns) do
    ~H"""
    <li id={@issue.id} class="mb-1">
      <span class="line-through text-gray-500">{@issue.title}</span>
    </li>
    """
  end
end
