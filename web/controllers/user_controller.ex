defmodule OxleasAdhd.UserController do
  use OxleasAdhd.Web, :controller
  alias OxleasAdhd.User

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, %{"user_type" => user_type}) do
    changeset = User.changeset_staff(%User{})
    conn
    |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
  end

  def create(conn, %{"user" => user}) do
    user_type = user["user_type"]
    changeset = User.changeset_staff(%User{}, user)

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, ["User created successfully"])
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, ["User could not be created"])
        |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
    end
  end
end
