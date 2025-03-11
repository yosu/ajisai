defmodule AjisaiWeb.IssueLive.FormComponent do
  use AjisaiWeb, :live_component

  alias Ajisai.Plan

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="issue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <!--.input field={@form[:id]} type="text" label="Issue" /-->
        <.input field={@form[:title]} type="text" label="タイトル" />
        <:actions>
          <.button phx-disable-with="保存中...">保存</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{issue: issue} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Plan.change_issue(issue))
     end)}
  end

  @impl true
  def handle_event("validate", %{"issue" => issue_params}, socket) do
    changeset = Plan.change_issue(socket.assigns.issue, issue_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"issue" => issue_params}, socket) do
    save_issue(socket, socket.assigns.action, issue_params)
  end

  defp save_issue(socket, :edit, issue_params) do
    case Plan.update_issue(socket.assigns.issue, issue_params) do
      {:ok, issue} ->
        notify_parent({:saved, issue})

        {:noreply,
         socket
         |> put_flash(:info, "更新に成功しました")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_issue(socket, :new, issue_params) do
    user = socket.assigns.current_user

    case Plan.create_issue(Enum.into(%{"user_id" => user.id}, issue_params)) do
      {:ok, issue} ->
        notify_parent({:saved, issue})

        {:noreply,
         socket
         |> put_flash(:info, "作成に成功しました")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
