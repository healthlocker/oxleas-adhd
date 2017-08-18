defmodule Healthlocker.OxleasAdhd.CaseloadController do
  use Healthlocker.Web, :controller
  alias OxleasAdhd.ClinicianQuery
  alias Healthlocker.{Clinician, User}

  def index(conn, _params) do
    clinician = conn.assigns.current_user
    patients = get_patients(clinician)

    conn
    |> render("index.html", patients: patients)
  end

  def get_patients(clinician) do
    Clinician
    |> ClinicianQuery.get_patients_for_staff(clinician.id)
    |> Repo.all
    |> Enum.map(fn id ->
      Repo.get!(User, id)
      |> Repo.preload(:rooms)
      |> Repo.preload(carers: :rooms)
    end)
  end
end
