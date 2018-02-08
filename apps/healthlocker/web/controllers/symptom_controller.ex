defmodule Healthlocker.SymptomController do
  use Healthlocker.Web, :controller
  alias Healthlocker.Symptom

  def new(conn, _params) do
    case Repo.get_by(Symptom, user_id: conn.assigns.current_user.id) do
      nil ->
        changeset = Symptom.changeset(%Symptom{})
        conn
        |> render("new.html", changeset: changeset)
      _ ->
        conn
        |> put_flash(:error, "You can only set up your problem tracker once. Track your problem now.")
        |> redirect(to: symptom_tracker_path(conn, :new))
    end
  end

  def create(conn, %{"symptom" => symptom}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:symptoms)
      |> Symptom.changeset(symptom)

    case Repo.insert(changeset) do
      {:ok, _symptom} ->
        conn
        |> redirect(to: symptom_tracker_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
