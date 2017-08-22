defmodule Healthlocker.Plugs.RequireCorrectUser do
  import Plug.Conn

  def redirect_to_home(conn, user_id) do
    user_id = if is_binary(user_id) do
      String.to_integer(user_id)
    else
      user_id
    end

    if conn.assigns.current_user.id !== user_id do
      conn
      |> Phoenix.Controller.put_flash(:error,  "You cannot access that page")
      |> Phoenix.Controller.redirect(to: Healthlocker.Router.Helpers.page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
