defmodule App.CaseloadController do
  use App.Web, :controller

  alias App.{User, Plugs.Auth, DecryptUser, Clinician}

  def index(conn, _params) do
    cond do
      !conn.assigns[:current_user] ->
        conn
        |> put_flash(:error,  "You must be logged in to access that page!")
        |> redirect(to: login_path(conn, :index))
        |> halt
      conn.assigns.current_user.role == "clinician" ->
        clinician = conn.assigns.current_user
        patients = get_patients(clinician)
        render(conn, "index.html", hl_users: patients.hl_users)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def get_patients(clinician) do
    query = from c in Clinician, where: c.clinician_id == ^clinician.id
    patient_ids = Repo.all(query)

    hl_users = patient_ids
              |> Enum.map(fn map ->
                Repo.all(from u in User,
                where: u.id == ^map.caring_id,
                preload: [carers: :rooms],
                preload: [:rooms])
              end)
              |> Enum.concat

    %{hl_users: hl_users}
  end
end
