defmodule App.SymptomController do
  use App.Web, :controller
  alias App.Symptom

  def new(conn, _params) do
    changeset = Symptom.changeset(%Symptom{})
    render conn, "new.html", changeset: changeset
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
        render conn, "new.html", changeset: changeset
    end
  end
end
