defmodule Healthlocker.OxleasAdhd.AboutMeController do
  alias Healthlocker.{AboutMe, User}
  use Healthlocker.Web, :controller

  def new(conn, %{"user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    changeset = AboutMe.changeset(%AboutMe{})
    about_me_query = from am in AboutMe, where: am.user_id == ^user_id

    case Repo.all(about_me_query) do
      [about_me | _] ->
        conn
        |> redirect(to: user_about_me_path(conn, :edit, user, about_me))
      _ ->
        conn
        |> render("new.html", changeset: changeset, user: user)
    end
  end

  def create(conn, %{"about_me" => about_me, "user_id" => user_id}) do
    user = conn.assigns.current_user
    service_user = Repo.get!(User, user_id)
    changeset =
      case user.id == service_user.id do
        true ->
          service_user
          |> build_assoc(:about_mes)
          |> AboutMe.changeset(about_me)
          |> AboutMe.user_updated()
        _    ->
          user
          |> build_assoc(:about_mes)
          |> AboutMe.changeset(about_me)
          |> AboutMe.team_updated(service_user.id, user.id)
      end

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        case user.id == service_user.id do
          true ->
            conn
            |> put_flash(:info, ["About me saved successfully"])
            |> redirect(to: toolkit_path(conn, :index))
          false ->
            conn
            |> put_flash(:info, ["Updated service users about me"])
            |> redirect(to: caseload_user_path(conn, :show, service_user, section: "details"))
        end
      {:error, changeset} ->
        conn
        |> put_flash(:error, ["Something went wrong, please try again"])
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => about_me_id, "user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    about_me = Repo.get(AboutMe, about_me_id)
    adhd_team_member =
      case about_me.last_updated_by do
        nil -> nil
        _   -> Repo.get(User, about_me.last_updated_by)
      end
    team_name = AboutMe.format_team_name(adhd_team_member)
    team_last_update = AboutMe.format_naive_date(about_me.team_last_update)
    user_last_update = AboutMe.format_naive_date(about_me.my_last_update)
    changeset = AboutMe.changeset(about_me)
    conn
    |> render("edit.html", changeset: changeset, about_me: about_me, user: user,
              team_name: team_name, team_last_update: team_last_update,
              user_last_update: user_last_update)
  end

  def update(conn, %{"id" => about_me_id, "about_me" => about_me, "user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    old_about_me = Repo.get(AboutMe, about_me_id)
    adhd_team_member =
      case old_about_me.last_updated_by do
        nil -> nil
        _   -> Repo.get(User, old_about_me.last_updated_by)
      end
    team_name = AboutMe.format_team_name(adhd_team_member)
    team_last_update = AboutMe.format_naive_date(old_about_me.team_last_update)
    user_last_update = AboutMe.format_naive_date(old_about_me.my_last_update)
    changeset =
      AboutMe.changeset(old_about_me, about_me)
      |> AboutMe.user_updated()

    case Repo.update(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, ["Updated About Me"])
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        conn
    |> render("edit.html", changeset: changeset, about_me: old_about_me,
              user: user, team_last_update: team_last_update,
              user_last_update: user_last_update, team_name: team_name)
    end
  end
end
