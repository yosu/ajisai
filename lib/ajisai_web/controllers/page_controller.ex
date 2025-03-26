defmodule AjisaiWeb.PageController do
  use AjisaiWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/issues")
    else
      render(conn, :home, layout: false)
    end
  end
end
