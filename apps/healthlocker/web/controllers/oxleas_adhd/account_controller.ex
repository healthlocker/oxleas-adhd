defmodule Healthlocker.OxleasAdhd.AccountController do
  use Healthlocker.Web, :controller
  alias Healthlocker.User
  alias Healthlocker.Plugs.Auth
  use Timex

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = User
          |> Repo.get!(user_id)
          |> Repo.preload(:caring)
    changeset = User.update_changeset(user)
    conn
    |> render("index.html", changeset: changeset, user: user,
              action: account_path(conn, :update))
  end

  def update(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id) |> Repo.preload(:caring)

    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("index.html", changeset: changeset, user: user,
                action: account_path(conn, :update))
    end
  end

  def consent(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.update_data_access(user)
    conn
    |> render("consent.html", changeset: changeset, user: user,
                        action: account_path(conn, :update_consent))
  end

  def update_consent(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_data_access(user, user_params)

    case Repo.update(changeset) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updated successfully!")
        |> redirect(to: account_path(conn, :consent))
      {:error, changeset} ->
        conn
        |> render("consent.html", changeset: changeset, user: user,
                  action: account_path(conn, :update_consent))
    end
  end

  def edit_password(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)
    changeset = User.password_changeset(%User{})
    conn
    |> render("edit_password.html", changeset: changeset, user: user,
                    action: account_path(conn, :update_password))
  end

  def update_password(conn, %{"user" => user_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get!(User, user_id)

    changeset = User.update_password(user, user_params)
    case Auth.check_password(conn, user_id, user_params["password_check"], repo: Repo) do
      {:ok, conn} ->

        case Repo.update(changeset) do
          {:ok, _params} ->
            conn
            |> put_flash(:info, "Password updated successfully!")
            |> redirect(to: account_path(conn, :edit_password))
          {:error, changeset} ->
            conn
            |> render("edit_password.html", changeset: changeset, user: user,
                         action: account_path(conn, :update_password))
        end
      {:error, _reason, conn} ->
        changeset = changeset
        |> Ecto.Changeset.add_error(:password_check, "Does not match")

        conn
        |> put_flash(:error, "Incorrect current password")
        |> render("edit_password.html", changeset: %{changeset | action: :update},
                user: user, action: account_path(conn, :update_password))
    end
  end
end
