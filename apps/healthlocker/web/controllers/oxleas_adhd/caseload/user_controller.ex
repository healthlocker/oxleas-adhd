defmodule Healthlocker.OxleasAdhd.Caseload.UserController do
  use Healthlocker.Web, :controller
  use Timex
  alias Healthlocker.SleepTracker
  alias Healthlocker.{User, Goal, Post, OxleasAdhd.ServiceUser, Room, Answer}

  def show_teacher(conn, %{"su_id" => su_id, "room" => room_id, "teacher" => teacher_id}) do
    teacher = Repo.get(User, teacher_id)
    su = Repo.get(User, su_id)
    questions = Answer.get_questions
    answers = Repo.all(from a in Answer, where: a.su_id == ^su_id) |> Answer.format_answers_for_frontend
    q_and_a = Answer.make_question_answer_tuple(questions, answers)

    room = Repo.get(Room, room_id)
    conn
    |> render("teacher_details.html", teacher: teacher, q_and_a: q_and_a, service_user: su, room: room)
  end

  def show(conn, %{"id" => id, "section" => section, "date" => date, "shift" => shift}) do
    date = Date.from_iso8601!(date)
    shifted_date = case shift do
      "prev" ->
        Timex.shift(date, days: -7)
      "next" ->
        Timex.shift(date, days: 7)
      end

    current_user = conn.assigns.current_user
    details = get_details(id, shifted_date, current_user)

    conn
    |> render(String.to_atom(section), user: details.user, goals: details.goals,
    strategies: details.strategies, room: details.room,
    service_user: details.service_user, sleep_data: details.sleep_data,
    date: details.date, symptom_data: details.symptom_data,
    diary_data: details.diary_data, merged_data: details.merged_data,
    medication: details.medication
    )
  end

  def show(conn, %{"id" => user_id, "section" => section}) do
    current_user = conn.assigns.current_user
    details = get_details(user_id, Date.utc_today(), current_user)

    conn
    |> render(String.to_atom(section), user: details.user, goals: details.goals,
    strategies: details.strategies, room: details.room,
    service_user: details.service_user, sleep_data: details.sleep_data,
    date: details.date, symptom_data: details.symptom_data,
    diary_data: details.diary_data, merged_data: details.merged_data,
    medication: details.medication)
  end

  defp get_details(id, date, current_user) do
    user = Repo.get!(User, id) |> Repo.preload(:medication)
    room =
      case current_user.role do
        "teacher" ->
          teacher_room = "teacher-care-team:" <> Integer.to_string(user.id) <> ":" <> Integer.to_string(current_user.id)
          query = from r in Room, where: r.name == ^teacher_room
          Repo.all(query) |> List.first
        _ ->
          Repo.one! assoc(user, :rooms)
      end

    service_user = ServiceUser.for(user)
    medication = user.medication

    goals = Goal
          |> Goal.get_goals(id)
          |> Repo.all
    strategies = Post
                |> Post.get_coping_strategies(id)
                |> Repo.all

    sleep_data = SleepTracker
      |> SleepTracker.get_sleep_data(service_user.id, date)
      |> Repo.all

    date = Date.to_iso8601(date)
    {:ok, date_time, _} = DateTime.from_iso8601(date <> "T23:59:59Z")

    symptom_data = Healthlocker.TrackerController.get_symptom_tracking_data(date_time, service_user.id)
    diary_data = Healthlocker.TrackerController.get_diary_data(date_time, service_user.id)
    merged_data = Healthlocker.TrackerController.merge_tracking_data([], sleep_data, symptom_data, diary_data, DateTime.to_naive(date_time))

    %{user: user, room: room, service_user: service_user, goals: goals,
    strategies: strategies, sleep_data: sleep_data,
    date: date, symptom_data: symptom_data, diary_data: diary_data,
    merged_data: merged_data, medication: medication}
  end
end
