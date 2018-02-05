defmodule Healthlocker.OxleasAdhd.AnswerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{SchoolFeedback, User, AboutMe, Answer}

  def new(conn, %{"user_id" => su_id}) do
    service_user = Repo.get!(User, su_id)
    question_list = for x <- 1..7, do: "questions_sec" <> Integer.to_string(x)
    all_questions = Enum.map(question_list, &Answer.get_section/1)
    query = from a in Answer, where: a.su_id == ^su_id

    case Repo.all(query) do
      [] ->
        conn
        |> render("new.html", su: service_user, q_and_a: all_questions, route: "new")
      [answer | _] ->
        conn
        |> put_flash(:info, "change this route to redirect to edit route")
        |> redirect(to: user_answer_path(conn, :edit, service_user, answer))
    end
  end

  def create(conn, %{"data" => data, "user_id" => su_id}) do
    service_user = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    answers =
      Map.keys(data)
      |> Enum.map(fn key ->
        {key, data[key]}
      end)
      |> Enum.map(fn {key, list} ->
        Enum.map(list, fn {question, answer} ->
          %{ section: key, question: question, answer: answer,
            su_id: service_user.id, last_updated_by_id: teacher.id,
            inserted_at: DateTime.utc_now, updated_at: DateTime.utc_now }
        end)
      end)
      |> List.flatten

    case Repo.insert_all(Answer, answers) do
      test ->
        conn
        |> put_flash(:info, ["Saved the feedback form"])
        |> redirect(to: caseload_user_path(conn, :show, service_user, section: "details"))
    end
  end

  def edit(conn, %{"id" => ans_id, "user_id" => su_id}) do
    ans = Repo.get(Answer, ans_id)
    service_user = Repo.get!(User, su_id)

    question_list = for x <- 1..7, do: "questions_sec" <> Integer.to_string(x)
    questions = Enum.map(question_list, &Answer.get_section/1)

    answers =
      Repo.all( from a in Answer, where: a.su_id == ^su_id )
      |> Enum.reduce(%{}, fn x, y ->
        Map.update(y, x.section, [x], (fn i -> List.insert_at(i, -1, x) end))
      end)
      |> Enum.map(fn {key, ans_list} ->
        Enum.sort(ans_list, fn a, b -> String.to_integer(a.question) < String.to_integer(b.question) end)
      end)
      |> Enum.map(fn list ->
        Enum.map(list, fn map -> map.answer end)
      end)

    q_and_a =
      0..6
      |> Enum.map(fn index ->
        Enum.zip(Enum.at(questions, index), Enum.at(answers, index))
      end)

    conn
    |> put_flash(:info, "in edit")
    |> render("edit.html", su: service_user, q_and_a: q_and_a, ans: ans, route: "edit")
  end

  def update(conn, %{"data" => data, "user_id" => su_id}) do
    service_user = Repo.get!(User, su_id)
    teacher = conn.assigns.current_user
    answers =
      Map.keys(data)
      |> Enum.map(fn key ->
        {key, data[key]}
      end)
      |> Enum.map(fn {key, list} ->
        Enum.map(list, fn {question, answer} ->
          %{ section: key, question: question, answer: answer,
            su_id: service_user.id, last_updated_by_id: teacher.id,
            inserted_at: DateTime.utc_now, updated_at: DateTime.utc_now }
        end)
      end)
      |> List.flatten

    Ecto.Multi.new
    |> Ecto.Multi.delete_all(:del_answers, (from a in Answer, where: a.su_id == ^su_id))
    |> Ecto.Multi.insert_all(:answers, Answer, answers)
    |> Repo.transaction()

    conn
    |> put_flash(:info, ["Updated the feedback form"])
    |> redirect(to: caseload_user_path(conn, :show, service_user, section: "details"))
  end
end
