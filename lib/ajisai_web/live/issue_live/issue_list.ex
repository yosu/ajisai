defmodule AjisaiWeb.IssueLive.IssueList do
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
    <li id={@issue.id}>
      <.link
        phx-click={JS.push("delete", value: %{id: @issue.id}) |> hide("##{@issue.id}")}
        data-confirm={"Are you sure?\n#{@issue.title}"}
        data-test="delete"
      >
        <.icon name="hero-archive-box-x-mark" />
      </.link>
      <.link patch={~p"/issues/#{@issue}/edit"} data-test="edit">
        {@issue.title}
      </.link>
    </li>
    """
  end
end
