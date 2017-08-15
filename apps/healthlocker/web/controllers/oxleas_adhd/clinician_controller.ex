defmodule Healthlocker.OxleasAdhd.ClinicianController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, Clinician, OxleasAdhd.CreateRoom}
  alias OxleasAdhd.{ClinicianQuery, UserQuery}

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

    clinician_ids =
      clinician_params
      |> Map.values
      |> Enum.reject(fn (selection) ->
        selection == "false"
      end)
      |> Enum.map(fn id ->
        String.to_integer(id)
      end)

    clinicians = make_clinicians(id, clinician_ids)
    query = Clinician |> ClinicianQuery.get_staff_for_service_user(id)
    multi = CreateRoom.connect_clinicians_and_create_rooms(service_user, clinician_ids, clinicians, query)
    case Repo.transaction(multi) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Staff connected")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
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
        clinician_id: clinician_id
      }
    end)
  end
end
