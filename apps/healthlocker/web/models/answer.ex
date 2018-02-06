defmodule Healthlocker.Answer do
  use Healthlocker.Web, :model

  schema "answers" do
    field :section, :string
    field :question, :string
    field :answer, :string
    belongs_to :su, Healthlocker.User, foreign_key: :su_id
    belongs_to :last_updated_by, Healthlocker.User, foreign_key: :last_updated_by_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:section, :question, :answer, :su_id, :last_updated_by_id])
    |> validate_required([:su, :last_updated_by])
  end

  # helpers
  def get_section(str) do
    Healthlocker.ComponentView.get_options(str)
    |> Enum.with_index(1)
    |> index_to_atom
  end

  def index_to_atom(list) do
    Enum.map(list, fn {q, key} ->
      atom = key |> Integer.to_string |> String.to_atom
      {q, atom}
    end)
  end

  def get_questions do
    question_list = for x <- 1..7, do: "questions_sec" <> Integer.to_string(x)
    Enum.map(question_list, &get_section/1)
  end

  def format_answers_for_frontend(answers) do
    answers
    |> Enum.reduce(%{}, fn x, y ->
      Map.update(y, x.section, [x], (fn i -> List.insert_at(i, -1, x) end))
    end)
    |> Enum.map(fn {key, ans_list} ->
      Enum.sort(ans_list, fn a, b -> String.to_integer(a.question) < String.to_integer(b.question) end)
    end)
    |> Enum.map(fn list ->
      Enum.map(list, fn map -> map.answer end)
    end)
  end

  def format_answers_for_db(data, su, teacher) do
    Map.keys(data)
    |> Enum.map(fn key ->
      {key, data[key]}
    end)
    |> Enum.map(fn {key, list} ->
      Enum.map(list, fn {question, answer} ->
        %{ section: key, question: question, answer: answer,
          su_id: su.id, last_updated_by_id: teacher.id,
          inserted_at: DateTime.utc_now, updated_at: DateTime.utc_now }
      end)
    end)
    |> List.flatten
  end

  def make_question_answer_tuple(questions, answers) do
      0..6
      |> Enum.map(fn index ->
        Enum.zip(Enum.at(questions, index), Enum.at(answers, index))
      end)
  end
end
