defmodule AjisaiWeb.IssueLive.IssueList do
  @moduledoc false
  use AjisaiWeb, :component

  alias Ajisai.Plan.Issue

  attr :issues, :list, required: true

  def issue_list(assigns) do
    ~H"""
    <ul id="issues" phx-update="stream">
      <.issue_item :for={{dom_id, issue} <- @issues} issue={issue} dom_id={dom_id} />
    </ul>
    """
  end

  attr :dom_id, :string, required: true
  attr :issue, Issue, required: true

  defp issue_item(assigns) do
    ~H"""
    <li id={@dom_id} class="mb-1 hover:bg-zinc-100">
      <.link
        phx-click={JS.push("close", value: %{id: @issue.id}) |> hide("##{@dom_id}")}
        data-test="close"
      >
        <.icon name="hero-archive-box-arrow-down" class="bg-green-600" />
      </.link>
      <.link patch={~p"/issues/#{@issue}/edit"} data-test="edit">
        {@issue.title}
      </.link>
    </li>
    """
  end
end
