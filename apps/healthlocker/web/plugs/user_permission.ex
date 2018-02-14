defmodule Healthlocker.Plugs.RequireCorrectUser do
  import Plug.Conn

  def redirect_to_home(conn, user_id) do
    current_user_id = conn.assigns.current_user.id
    su = Healthlocker.Repo.get(Healthlocker.User, user_id)
    user_id =
      if is_binary(user_id) do
        String.to_integer(user_id)
      else
        user_id
      end

    is_service_users_teacher? =
      if su do
        su
        |> Healthlocker.Repo.preload(:teacher)
        |> Map.get(:teacher)
        |> Enum.map(fn teacher -> teacher.id end)
        |> Enum.member?(current_user_id)
      else
        false
      end

    if current_user_id !== user_id && !is_service_users_teacher? do
      conn
      |> Phoenix.Controller.put_flash(:error,  "You cannot access that page")
      |> Phoenix.Controller.redirect(to: Healthlocker.Router.Helpers.page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
