defmodule Healthlocker.OxleasAdhd.ClinicianController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, Clinician, Teacher, Room, OxleasAdhd.CreateRoom, OxleasAdhd.EditRoom}
  alias OxleasAdhd.{ClinicianQuery, TeacherQuery, UserQuery}

  def edit(conn, %{"user_id" => user_id} = params) do
    service_user =
      User
      |> Repo.get!(user_id)
      |> Repo.preload(:clinician)
      |> Repo.preload(:teacher)

    selected_clinicians = get_staff("clinician") |> selected_staff(service_user.clinician)
    selected_teachers = get_staff("teacher") |> selected_staff(service_user.teacher)

    conn
    |> assign(:edit, true)
    |> render_helper("edit.html", service_user, selected_clinicians, selected_teachers)
  end

  def update(conn, %{"user_id" => user_id, "links" => %{"clinicians" => clinician_params, "teachers" => teacher_params, "s_user" => email}}) do
    id = user_id |> String.to_integer
    service_user =
      User
      |> Repo.get!(id)
      |> Repo.preload(:clinician)
      |> Repo.preload(:teacher)

    selected_clinicians = get_staff("clinician") |> selected_staff(service_user.clinician)
    selected_teachers = get_staff("teacher") |> selected_staff(service_user.teacher)

    user_changeset = User.update_email_changeset(service_user, email)

    clinician_ids = get_user_ids(clinician_params)
    teacher_ids = get_user_ids(teacher_params)

    room = Room |> Repo.get_by(name: "service-user-care-team:" <> Integer.to_string(id))
    clinicians = make_clinicians(id, clinician_ids)
    teachers = make_teachers(id, teacher_ids)
    query = Clinician |> ClinicianQuery.get_staff_for_service_user(id)
    query_teacher = Teacher |> TeacherQuery.get_teachers_for_service_user(id)

    multi_clinician = EditRoom.connect_clinicians_and_update_rooms(room, clinician_ids, clinicians, query)
    multi_teacher = EditRoom.connect_teachers_and_update_rooms(room, teacher_ids, teachers, query_teacher)
    su_email_multi = User.update_su_email(user_changeset)

    multis =
      multi_clinician
      |> Ecto.Multi.append(multi_teacher)
      |> Ecto.Multi.append(su_email_multi)

    failed_email_update_msg = "Something went wrong updating the service user's email. Please try again"
    failed_team_update_msg = "Could not create connection. Please try again."
    case Repo.transaction(multis) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, "Updates saved")
        |> redirect(to: user_path(conn, :index))
      {:error, :update_su_email, changeset, data} ->
        conn
        |> put_flash(:error, failed_email_update_msg)
        |> render_helper("edit.html", service_user, selected_clinicians, selected_teachers)
      {:error, name, changeset, data} ->
        conn
        |> put_flash(:error, failed_team_update_msg)
        |> render_helper("edit.html", service_user, selected_clinicians, selected_teachers)
    end
  end

  def new(conn, %{"user_id" => user_id}) do
    service_user = Repo.get!(User, user_id)

    clinicians =
      get_staff("clinician")
      |> Enum.map(fn(c) ->
        Map.put(c, :selected, false)
      end)

    teachers =
      get_staff("teacher")
      |> Enum.map(fn(c) ->
        Map.put(c, :selected, false)
      end)

    conn
    |> render_helper("new.html", service_user, clinicians, teachers)
  end

  def create(conn, %{"user_id" => user_id, "links" => %{"clinicians" => clinician_params, "teachers" => teacher_params}}) do
    id = user_id |> String.to_integer
    service_user = Repo.get!(User, id)

    clinician_ids = get_user_ids(clinician_params)
    teacher_ids = get_user_ids(teacher_params)

    clinicians = make_clinicians(id, clinician_ids)
    multi = CreateRoom.connect_clinicians_and_create_rooms(service_user, clinician_ids, clinicians)

    teachers = make_teachers(id, teacher_ids)
    multi_teacher = CreateRoom.connect_teachers_and_create_rooms(service_user, teacher_ids, teachers)

    case Repo.transaction(Ecto.Multi.append(multi, multi_teacher)) do
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

  defp make_teachers(user_id, teachers_list) do
    teachers_list
    |> Enum.map(fn(teacher_id) ->
      %{
        caring_id: user_id,
        teacher_id: teacher_id
      }
    end)
  end

  defp get_user_ids(user_params) do
    user_params
    |> Enum.reject(fn({_, v}) -> v == "false" end)
    |> Enum.map(fn({id, _}) -> String.to_integer(id) end)
  end

  def get_staff(staff_type) do
      User
      |> UserQuery.get_by_user_type(staff_type)
      |> Repo.all
  end

  def selected_staff(staff_members, staff_list) do
    staff_members
    |> Enum.map(fn(c) ->
      Map.put(c, :selected, Enum.member?(staff_list, c))
    end)
  end

  def render_helper(conn, html, service_user, clinicians, teachers) do
    conn
    |> render(html, user: service_user, clinicians: clinicians, teachers: teachers)
  end
end
