defmodule Healthlocker.OxleasAdhd.SchoolFeedbackController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{SchoolFeedback, User, AboutMe}

  def index(conn, %{"user_id" => user_id}) do
    service_user = Repo.get(User, user_id)
    query = from sf in SchoolFeedback, where: sf.user_id == ^user_id

    case Repo.all(query) do
      [feedback | _] ->
        conn
        |> redirect(to: user_school_feedback_path(conn, :show, service_user, feedback))
      _ ->
        conn
        |> render("index.html")
    end
  end

  def show(conn, %{"user_id" => su_id, "id" => feedback_id}) do
    combos = SchoolFeedback.create_question_key_combo
    feedback = Repo.get(SchoolFeedback, feedback_id)

    conn
    |> render("show.html", combos: combos, feedback: feedback)
  end

  def new(conn, %{"user_id" => su_id}) do
    combos = SchoolFeedback.create_question_key_combo
    service_user = Repo.get!(User, su_id)
    changeset = SchoolFeedback.changeset(%SchoolFeedback{})

    sch_feedback_query =
      from sf in SchoolFeedback,
      where: sf.user_id == ^su_id,
      order_by: [desc: sf.inserted_at]

    case Repo.all(sch_feedback_query) do
      [feedback | _] ->
        conn
        |> redirect(
          to: user_school_feedback_path(conn, :edit, service_user, feedback)
        )
      _ ->
        conn
        |> render(
          "new.html", changeset: changeset, user: service_user,
          combos: combos
        )
    end
  end

  def create(conn, %{"school_feedback" => feedback, "user_id" => su_id}) do
    teacher = conn.assigns.current_user
    service_user = Repo.get!(User, su_id)
    changeset =
      conn.assigns.current_user
      |> build_assoc(:school_feedbacks)
      |> SchoolFeedback.changeset(feedback)
      |> SchoolFeedback.update_su_teacher_ids(service_user.id, teacher.id)

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, ["Saved the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, service_user, section: "details"))
      {:error, changeset} ->
        conn
        |> put_flash(:error, ["Something went wrong, please try again"])
        |> render("new.html", changeset: changeset, user: service_user)
    end
  end

  def edit(conn, %{"id" => feedback_id, "user_id" => su_id}) do
    combos = SchoolFeedback.create_question_key_combo
    service_user = Repo.get(User, su_id)
    feedback = Repo.get(SchoolFeedback, feedback_id)
    last_updated_by = Repo.get(User, feedback.last_updated_by)
    teacher_name = AboutMe.format_team_name(last_updated_by)
    last_update = AboutMe.format_naive_date(feedback.updated_at)

    changeset = SchoolFeedback.changeset(feedback)
    conn
    |> render(
      "edit.html", changeset: changeset, feedback: feedback,
      teacher_name: teacher_name, user: service_user, last_update: last_update,
      combos: combos
    )
  end

  def update(conn, %{"id" => feedback_id, "school_feedback" => feedback, "user_id" => su_id}) do
    teacher = conn.assigns.current_user
    service_user = Repo.get(User, su_id)
    old_feedback = Repo.get(SchoolFeedback, feedback_id)
    last_updated_by = Repo.get(User, old_feedback.last_updated_by)
    teacher_name = AboutMe.format_team_name(last_updated_by)
    last_update = AboutMe.format_naive_date(old_feedback.updated_at)

    changeset =
      old_feedback
      |> SchoolFeedback.changeset(feedback)
      |> SchoolFeedback.update_su_teacher_ids(service_user.id, teacher.id)

    case Repo.update(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, ["Updated the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, service_user, section: "details"))
      {:error, changeset} ->
        conn
        |> put_flash(:error, ["Something went wrong, please try again"])
        |> render(
          "edit.html", changeset: changeset, user: service_user,
          feedback: old_feedback, teacher_name: teacher_name,
          last_update: last_update
        )
    end
  end
end
