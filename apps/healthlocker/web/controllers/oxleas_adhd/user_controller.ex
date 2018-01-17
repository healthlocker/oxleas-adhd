defmodule Healthlocker.OxleasAdhd.UserController do
  use Healthlocker.Web, :controller
  alias Healthlocker.User

  def index(conn, _params) do
    query = OxleasAdhd.UserQuery.get_by_user_type(User, "service_user")
    users =
      Repo.all(query)
      |> Enum.map(fn user ->
        user |> Repo.preload(:carers)
      end )
    staff = User |> OxleasAdhd.UserQuery.get_by_user_type("clinician") |> Repo.all
    teachers = User |> OxleasAdhd.UserQuery.get_by_user_type("teacher") |> Repo.all
    conn
    |> render("index.html", users: users, staff: staff, teachers: teachers)
  end

  def new(conn, %{"user_type" => user_type}) do
    changeset = changeset_from_user_type(user_type)
    conn
    |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
  end

  def create(conn, %{"user" => user}) do
    user_type = user["user_type"]
    changeset = changeset_from_user_type(user_type, user)

    case user_type do
      "new_service_user" ->
        case Repo.insert(changeset) do
          {:ok, service_user} ->
            conn
            |> put_flash(:info, "Please pick the care team for this user")
            |> redirect(to: user_clinician_path(conn, :new, service_user))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "User could not be created")
            |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
        end
      "new_carer" ->
        case Repo.insert(changeset) do
          {:ok, carer} ->
            conn
            |> put_flash(:info, "Please enter the service user this carer should connect to")
            |> redirect(to: user_carer_path(conn, :new, carer))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Carer could not be created")
            |> render(String.to_atom(user_type), changeset: changeset, user_type: user_type)
        end
      _ ->
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
  end

  def edit(conn, %{"id" => user_id}) do
    service_user = Repo.get(User, user_id)
    changeset = User.changeset_service_user(service_user)
    conn
    |> render("edit.html", changeset: changeset, service_user: service_user)
  end

  def update(conn, %{"id" => user_id, "user" => user}) do
    old_user = Repo.get(User, user_id)
    changeset = User.changeset_service_user(old_user, user)

    case Repo.update(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "User created with care team")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, service_user: old_user
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
      "new_teacher" ->
        User.changeset_teacher(%User{}, user)
    end
  end
end
