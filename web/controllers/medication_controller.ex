defmodule OxleasAdhd.MedicationController do
  use OxleasAdhd.Web, :controller
  alias OxleasAdhd.{Medication, User}

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, %{"user_id" => id}) do
    user = Repo.get!(User, id)
    changeset = Medication.changeset(%Medication{})
    conn
    |> render("new.html", changeset: changeset, user: user)
  end
  end

  def edit(conn, params) do
    conn
    |> render("edit.html")
  end
end
