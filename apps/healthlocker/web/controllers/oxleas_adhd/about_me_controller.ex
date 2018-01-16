defmodule Healthlocker.OxleasAdhd.AboutMeController do
  alias Healthlocker.AboutMe
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


  def edit(conn, %{"id" => about_me_id}) do
    about_me = Repo.get(AboutMe, about_me_id)
    changeset = AboutMe.changeset(about_me)
    conn
    |> render("edit.html", changeset: changeset, about_me: about_me)
  end

  end
end
