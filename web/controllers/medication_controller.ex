defmodule OxleasAdhd.MedicationController do
  use OxleasAdhd.Web, :controller
  alias OxleasAdhd.{Medication, MedicationQuery, User}

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user = Repo.get!(User, user_id)
    medication = Medication
                |> MedicationQuery.get_medication_for_user(user_id, id)
                |> Repo.one

    conn
    |> render("show.html", user: user, medication: medication)
  end

  def new(conn, %{"user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    changeset = Medication.changeset(%Medication{})
    conn
    |> render("new.html", changeset: changeset, user: user)
  end

  def create(conn, %{"user_id" => id, "medication" => medication_params}) do
    user = Repo.get!(User, id)
    changeset = Medication.changeset(%Medication{}, medication_params)
      |> Ecto.Changeset.put_change(:user_id, String.to_integer(id))
    case Repo.insert(changeset) do
      {:ok, _medication} ->
        conn
        |> put_flash(:info, "Medication added")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error adding medication")
        |> render("new.html", changeset: changeset, user: user)
    end
  end

  def edit(conn, %{"user_id" => user_id, "id" => id}) do
    user = Repo.get!(User, user_id)
    medication = Medication
                |> Repo.get!(id)
    changeset = Medication.changeset(medication)

    conn
    |> render("edit.html", changeset: changeset, user: user, medication: medication)
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "medication" => medication_params}) do
    user = Repo.get!(User, user_id)
    medication = Medication
                |> Repo.get!(id)
    changeset = Medication.changeset(medication, medication_params)

    case Repo.update(changeset) do
      {:ok, _medication} ->
        conn
        |> put_flash(:info, "Medication edited")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error editing medication")
        |> render("edit.html", changeset: changeset, user: user, medication: medication)
    end
  end
end
