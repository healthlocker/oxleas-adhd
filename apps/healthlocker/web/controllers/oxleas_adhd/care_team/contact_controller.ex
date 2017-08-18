defmodule Healthlocker.OxleasAdhd.CareTeam.ContactController do
  use Healthlocker.Web, :controller
  alias OxleasAdhd.ClinicianQuery
  alias Healthlocker.{Clinician, User}

  def show(conn, _params) do
    service_user = Healthlocker.OxleasAdhd.ServiceUser.for(conn.assigns.current_user)
    care_team =
      Clinician
      |> ClinicianQuery.get_clinician_ids_for_user(service_user.id)
      |> Repo.all
      |> Enum.map(fn id ->
        Repo.get!(User, id)
      end)
    conn
    |> assign(:service_user, service_user)
    |> assign(:care_team, care_team)
    |> render("show.html")
  end
end
