defmodule OxleasAdhd.ClinicianController do
  use OxleasAdhd.Web, :controller
  alias OxleasAdhd.{User, UserQuery, Clinician}

  def new(conn, %{"user_id" => user_id}) do
    service_user = Repo.get!(User, user_id)
    clinicians = User
              |> UserQuery.get_by_user_type("clinician")
              |> Repo.all
    changeset = Clinician.changeset(%Clinician{})

    conn
    |> render("new.html", user: service_user, changeset: changeset, clinicians: clinicians)
  end

  def create(conn, %{"user_id" => user_id, "clinician" => clinician_params}) do
    id = user_id |> String.to_integer
    service_user = Repo.get!(User, id)
    changeset = Clinician.changeset(%Clinician{})

    clinician_ids =
      clinician_params
      |> Map.values
      |> Enum.reject(fn (selection) ->
        selection == "false"
      end)

    clinicians = make_clinicians(id, clinician_ids)
    case Repo.insert_all(Clinician, clinicians) do
      {n, nil} ->
        conn
        |> put_flash(:info, "Staff connected")
        |> redirect(to: user_path(conn, :index))
      _err ->
        conn
        |> put_flash(:error, "Could not create connection. Please try again.")
        |> render("new.html", user: service_user, changeset: changeset)
    end
  end

  defp make_clinicians(user_id, clinicians_list) do
    clinicians_list
    |> Enum.map(fn(clinician_id) ->
      %{
        caring_id: user_id,
        clinician_id: String.to_integer(clinician_id)
      }
    end)
  end
end
