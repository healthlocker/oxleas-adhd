defmodule OxleasAdhd.UserController do
  use OxleasAdhd.Web, :controller
  alias OxleasAdhd.User

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, %{"user_type" => user_type}) do
    changeset = changeset_from_user_type(user_type)
    conn
    |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
  end

  def create(conn, %{"user" => user}) do
    user_type = user["user_type"]
    changeset = changeset_from_user_type(user_type, user)

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "User could not be created")
        |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
    end
  end

  def changeset_from_user_type(user_type, user \\ %{}) do
    case user_type do
      "new_staff" ->
        User.changeset_staff(%User{}, user)
      "new_service_user" ->
        User.changeset_service_user(%User{}, user)
      "new_carer" ->
        User.changeset_carer(%User{}, user)
    end
  end
end
