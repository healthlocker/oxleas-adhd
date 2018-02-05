defmodule Healthlocker.OxleasAdhd.AnswerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{SchoolFeedback, User, AboutMe, Answer}

  def index(conn, %{"user_id" => user_id}) do
    su = Repo.get(User, user_id)
    query = from a in Answer, where: a.su_id == ^user_id

    case Repo.all(query) do
      [feedback | _] ->
        conn
        |> redirect(to: user_answer_path(conn, :show, su, feedback))
      _ ->
        conn
        |> render("index.html")
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    questions = Answer.get_questions
    answers = Repo.all(from a in Answer, where: a.su_id == ^user_id) |> Answer.format_answers_for_frontend(user_id)
    q_and_a = Answer.make_question_answer_tuple(questions, answers)

    conn
    |> render("show.html", q_and_a: q_and_a)
  end

  def new(conn, %{"user_id" => su_id}) do
    service_user = Repo.get!(User, su_id)
    questions = Answer.get_questions
    query = from a in Answer, where: a.su_id == ^su_id

    case Repo.all(query) do
      [] ->
        conn
        |> render("new.html", su: service_user, q_and_a: questions, route: "new")
      [answer | _] ->
        conn
        |> redirect(to: user_answer_path(conn, :edit, service_user, answer))
    end
  end

  def create(conn, %{"data" => data, "user_id" => su_id}) do
    su = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    answers = Answer.format_answers_for_db(data, su, teacher)

    case Repo.insert_all(Answer, answers) do
      test ->
        conn
        |> put_flash(:info, ["Saved the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, su, section: "details"))
    end
  end

  def edit(conn, %{"id" => ans_id, "user_id" => su_id}) do
    ans = Repo.get(Answer, ans_id)
    service_user = Repo.get!(User, su_id)

    questions = Answer.get_questions
    answers = Repo.all(from a in Answer, where: a.su_id == ^su_id) |> Answer.format_answers_for_frontend()
    q_and_a = Answer.make_question_answer_tuple(questions, answers)

    conn
    |> render("edit.html", su: service_user, q_and_a: q_and_a, ans: ans, route: "edit")
  end

  def update(conn, %{"data" => data, "user_id" => su_id}) do
    su = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    answers = Answer.format_answers_for_db(data, su, teacher)

    Ecto.Multi.new
    |> Ecto.Multi.delete_all(:del_answers, (from a in Answer, where: a.su_id == ^su_id))
    |> Ecto.Multi.insert_all(:answers, Answer, answers)
    |> Repo.transaction()

    conn
    |> put_flash(:info, ["Updated the feedback form"])
    |> redirect(to: caseload_user_path(conn, :show, su, section: "details"))
  end
end
