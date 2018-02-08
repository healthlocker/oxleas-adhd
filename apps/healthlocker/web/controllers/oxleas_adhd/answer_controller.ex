defmodule Healthlocker.OxleasAdhd.AnswerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, AboutMe, Answer}

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
    answers = Repo.all(from a in Answer, where: a.su_id == ^user_id) |> Answer.format_answers_for_frontend
    q_and_a = Answer.make_question_answer_tuple(questions, answers)

    conn
    |> render("show.html", q_and_a: q_and_a)
  end

  def new(conn, %{"user_id" => su_id}) do
    current_user_role = conn.assigns[:current_user].role
    su = Repo.get!(User, su_id)
    questions = Answer.get_questions
    query = from a in Answer, where: a.su_id == ^su_id

    case Repo.all(query) do
      [] ->
        case current_user_role do
          "teacher" ->
            conn
            |> render("new.html", su: su, q_and_a: questions, route: "new")
          "clinician" ->
            conn
            |> redirect(to: user_answer_path(conn, :index, su))
        end
      [answer | _] ->
        case current_user_role do
          "teacher" ->
            conn
            |> redirect(to: user_answer_path(conn, :edit, su, answer))
          "clinician" ->
            conn
            |> redirect(to: user_answer_path(conn, :show, su, answer))
        end
    end
  end

  def create(conn, %{"data" => data, "user_id" => su_id}) do
    su = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    questions = Answer.get_questions
    answers = Answer.format_answers_for_db(data, su, teacher)

    case Repo.insert_all(Answer, answers) do
      {num, nil} ->
        conn
        |> put_flash(:info, ["Saved the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, su, section: "details"))
      _error ->
        conn
        |> put_flash(:error, ["Something went wrong, please try again"])
        |> render("new.html", su: su, q_and_a: questions, route: "new")
    end
  end

  def edit(conn, %{"id" => ans_id, "user_id" => su_id}) do
    ans = Repo.get(Answer, ans_id)
    su = Repo.get!(User, su_id)

    questions = Answer.get_questions
    answers = Repo.all(from a in Answer, where: a.su_id == ^su_id) |> Answer.format_answers_for_frontend()
    q_and_a = Answer.make_question_answer_tuple(questions, answers)

    conn
    |> render("edit.html", su: su, q_and_a: q_and_a, ans: ans, route: "edit")
  end

  def update(conn, %{"data" => data, "user_id" => su_id, "id" => ans_id}) do
    ans = Repo.get(Answer, ans_id)
    su = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    answer_for_db = Answer.format_answers_for_db(data, su, teacher)
    questions = Answer.get_questions
    answers_for_frontend = Repo.all(from a in Answer, where: a.su_id == ^su_id) |> Answer.format_answers_for_frontend()
    q_and_a = Answer.make_question_answer_tuple(questions, answers_for_frontend)

    multi =
      Ecto.Multi.new
      |> Ecto.Multi.delete_all(:delete_answers, (from a in Answer, where: a.su_id == ^su_id))
      |> Ecto.Multi.insert_all(:insert_answers, Answer, answer_for_db)

    case Repo.transaction(multi) do
      {:ok, _params} ->
        conn
        |> put_flash(:info, ["Updated the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, su, section: "details"))
      {:error, _name, _changeset, _data} ->
        conn
        |> put_flash(:error, "Something went wrong, please try again")
        |> render("edit.html", su: su, q_and_a: q_and_a, ans: ans, route: "edit")
    end
  end
end
