defmodule OxleasAdhd.LoginController do
  use OxleasAdhd.Web, :controller

  alias OxleasAdhd.User
  alias OxleasAdhd.Plugs.Auth

  def index(conn, _) do
    conn
    |> render("index.html")
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    case Auth.email_and_pass_login(conn, String.downcase(email), pass, repo: Repo) do
      {:ok, conn} ->
        case conn.assigns.current_user.role do
          "super_admin" ->
            conn
            |> put_flash(:info, "Logged in as super admin")
            |> redirect(to: user_path(conn, :index))
          "clinician" ->
            conn
            |> put_flash(:info, "Logged in as clinician")
            |> redirect(to: page_path(conn, :index))
          _ ->
            conn
            |> put_flash(:info, "Welcome to Headscape Focus!")
            |> redirect(to: page_path(conn, :index))
        end
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("index.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
