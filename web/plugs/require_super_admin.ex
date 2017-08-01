defmodule OxleasAdhd.Plugs.RequireSuperAdmin do
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _) do
    current_user = conn.assigns[:current_user]
    if current_user do
      case Map.get(current_user, :role) do
        "super_admin" ->
          conn
        _ ->
          conn |> redirect_to_login
      end
    else
      conn |> redirect_to_login
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error,  "You must be super admin to access that page!")
    |> Phoenix.Controller.redirect(to: OxleasAdhd.Router.Helpers.page_path(conn, :index))
    |> halt
  end
end
