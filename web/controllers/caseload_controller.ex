defmodule App.CaseloadController do
  use App.Web, :controller

  alias App.{EPJSTeamMember, EPJSUser, User, Plugs.Auth, DecryptUser}

  def index(conn, _params) do
    cond do
      !conn.assigns[:current_user] ->
        conn
        |> put_flash(:error,  "You must be logged in to access that page!")
        |> redirect(to: login_path(conn, :index))
        |> halt
      conn.assigns.current_user.user_guid ->
        clinician = conn.assigns.current_user
        patients = get_patients(clinician)
        render(conn, "index.html", hl_users: patients.hl_users, non_hl: patients.non_hl)
      true ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def get_patients(clinician) do
    patient_ids = EPJSTeamMember
                  |> EPJSTeamMember.patient_ids(clinician.email)
                  |> ReadOnlyRepo.all

    hl_users = patient_ids
              |> Enum.map(fn id ->
                Repo.all(from u in User,
                where: u.slam_id == ^id,
                preload: [carers: :rooms],
                preload: [:rooms])
              end)
              |> Enum.concat

    non_hl = patient_ids
              |> Enum.map(fn id ->
                ReadOnlyRepo.all(from e in EPJSUser,
                where: e."Patient_ID" == ^id)
              end)
              |> Enum.concat
              |> Enum.reject(fn user ->
                Enum.any?(hl_users, fn hl ->
                  user."Patient_ID" == hl.slam_id
                end)
              end)
    %{hl_users: hl_users, non_hl: non_hl}
  end

  def compare_time(time_str) do
    case DateTime.from_iso8601(time_str <> "Z") do
      {:ok, datetime, _} ->
        DateTime.compare(datetime, DateTime.utc_now)
      _ ->
        :lt
    end
  end
end
