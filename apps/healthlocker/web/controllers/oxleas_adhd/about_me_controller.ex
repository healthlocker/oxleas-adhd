defmodule Healthlocker.OxleasAdhd.AboutMeController do
  alias Healthlocker.{AboutMe, User}
  use Healthlocker.Web, :controller

  def new(conn, params) do
    user_id = conn.assigns.current_user.id
    changeset = AboutMe.changeset(%AboutMe{})

    about_me_query = from am in AboutMe, where: am.user_id == ^user_id

    case Repo.all(about_me_query) do
      [about_me | _] ->
        conn
        |> redirect(to: about_me_path(conn, :edit, about_me))
      _ ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def create(conn, %{"about_me" => about_me}) do
    user = conn.assigns.current_user
    changeset =
      user
      |> build_assoc(:about_mes)
      |> AboutMe.changeset(about_me)
      |> AboutMe.user_updated()

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, ["About me saved successfully"])
        |> redirect(to: toolkit_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, ["Something went wrong, please try again"])
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => about_me_id}) do
    about_me = Repo.get(AboutMe, about_me_id)
    adhd_team_member =
      case about_me.last_updated_by do
        nil -> nil
        _   -> Repo.get(User, about_me.last_updated_by)
      end
    formatted_staff_info = AboutMe.format_staff_update_info(about_me, adhd_team_member)
    formatted_user_info = AboutMe.format_naive_date(about_me.my_last_update)
    changeset = AboutMe.changeset(about_me)
    conn
    |> render("edit.html", changeset: changeset, about_me: about_me,
              formatted_staff_info: formatted_staff_info,
              formatted_user_info: formatted_user_info)
  end

  def update(conn, %{"id" => about_me_id, "about_me" => about_me}) do
    old_about_me = Repo.get(AboutMe, about_me_id)
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
        |> render("edit.html", changeset: changeset, about_me: old_about_me)
    end
  end
end
