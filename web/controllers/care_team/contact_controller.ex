defmodule App.CareTeam.ContactController do
  use App.Web, :controller

  def show(conn, _params) do
    service_user = App.Slam.ServiceUser.for(conn.assigns.current_user)

    conn
    |> assign(:service_user, service_user)
    |> assign(:care_team, App.Slam.CareTeam.for(service_user))
    |> render("show.html")
  end
end
