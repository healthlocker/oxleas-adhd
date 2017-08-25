defmodule Healthlocker.OxleasAdhd.CarerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, Clinician, OxleasAdhd.CreateCarerRoom}
  alias OxleasAdhd.{ClinicianQuery, UserQuery}

  def new(conn, %{"user_id" => user_id}) do
    carer = Repo.get(User, user_id)
    conn
    |> render("new.html", carer: carer)
  end

  def submit_SU_details(conn, %{"su_info" => su_info, "user_id" => user_id}) do
    query = UserQuery.get_user_by_details(User, su_info)
    carer = Repo.get(User, user_id)
    service_user = Repo.one(query)

    case service_user do
      nil ->
        conn
        |> put_flash(:error, "No user found. Check the details you entered and
        try again. Or go back to see if there is an account for the person you
        are looking for, and if not create one first.")
        |> redirect(to: user_carer_path(conn, :new, carer))
      _ ->
        conn
        |> render("confirm.html", carer: carer, service_user: service_user)
    end
  end

  def confirm_SU_details(conn, %{"su_info" => su_info, "user_id" => carer_id}) do
    %{"service_user_id" => service_user_id} = su_info

    carer = Repo.get(User, carer_id)
    service_user = Repo.get(User, service_user_id)
    clinician_ids =
      Clinician
      |> ClinicianQuery.get_clinician_ids_for_user(service_user_id)
      |> Repo.all
    multi = CreateCarerRoom.connect_carers_and_create_rooms(carer, service_user, clinician_ids)
    case Repo.transaction(multi) do
      {:ok, _connect} ->
        conn
        |> put_flash(:info, "Carer connected to service user")
        |> redirect(to: user_path(conn, :index))
      {:error, _error} ->
        conn
        |> put_flash(:error, "Carer could not connect")
        |> render("confirm.html", carer: carer, service_user: service_user)
    end
  end
end
