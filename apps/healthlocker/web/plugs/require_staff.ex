defmodule Healthlocker.Plugs.RequireStaff do
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _) do
    current_user = conn.assigns[:current_user]
    if current_user do
      case Map.get(current_user, :role) do
        "clinician" ->
          conn
        _ ->
          conn |> redirect_to_home
      end
    else
      conn |> redirect_to_home
    end
  end

  defp redirect_to_home(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error,  "You must be a staff member to access that page!")
    |> Phoenix.Controller.redirect(to: Healthlocker.Router.Helpers.page_path(conn, :index))
    |> halt
  end
end
