defmodule Healthlocker.OxleasAdhd.CaseloadController do
  use Healthlocker.Web, :controller
  alias OxleasAdhd.{ClinicianQuery, TeacherQuery}
  alias Healthlocker.{Clinician, Teacher, User}

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    case current_user.role do
      "clinician" ->
        patients = get_patients_for_clinician(current_user)
        conn
        |> render("index.html", patients: patients, current_user: current_user)
      "teacher" ->
        patients = get_patients_for_teacher(current_user)
        conn
        |> render("index.html", patients: patients, current_user: current_user)
      _ ->
        conn
        |> redirect(to: toolkit_path(conn, :index))
    end
  end

  def get_patients_for_clinician(clinician) do
    Clinician
    |> ClinicianQuery.get_patients_for_staff(clinician.id)
    |> Repo.all
    |> Enum.map(fn id ->
      Repo.get!(User, id)
      |> Repo.preload(:rooms)
      |> Repo.preload(carers: :rooms)
    end)
  end

  def get_patients_for_teacher(teacher) do
    Teacher
    |> TeacherQuery.get_patients_for_teacher(teacher.id)
    |> Repo.all
    |> Enum.map(fn id ->
      Repo.get!(User, id)
      |> Repo.preload(:rooms)
      |> Repo.preload(carers: :rooms)
    end)
  end
end
