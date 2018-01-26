defmodule Healthlocker.SchoolFeedback do
  use Healthlocker.Web, :model

  schema "school_feedbacks" do
    field :p1q1, :string
    field :p1q2, :string
    field :p1q3, :string
    field :p1q4, :string
    field :p1q5, :string
    field :p1q6, :string
    field :p2q1, :string
    field :p2q2, :string
    field :p2q3, :string
    field :p3q1, :string
    field :p3q2, :string
    field :p3q3, :string
    field :p3q4, :string
    field :p4q1, :string
    field :p4q2, :string
    field :p4q3, :string
    field :p4q4, :string
    field :p4q5, :string
    field :p4q6, :string
    field :p4q7, :string
    field :p4q8, :string
    field :p4q9, :string
    field :p4q10, :string
    field :p5q1, :string
    field :p5q2, :string
    field :p5q3, :string
    field :p5q4, :string
    field :p5q5, :string
    field :p6q1, :string
    field :p6q2, :string
    field :p6q3, :string
    field :p6q4, :string
    field :p6q5, :string
    field :p7q1, :string
    field :p7q2, :string
    field :p7q3, :string
    field :p7q4, :string
    field :last_updated_by, :integer
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    fields = [
      :p1q1, :p1q2, :p1q3, :p1q4, :p1q5, :p1q6, :p2q1, :p2q2, :p2q3, :p3q1, :p3q2,
      :p3q3, :p3q4, :p4q1, :p4q2, :p4q3, :p4q4, :p4q5, :p4q6, :p4q7, :p4q8, :p4q9,
      :p4q10, :p5q1, :p5q2, :p5q3, :p5q4, :p5q5, :p6q1, :p6q2, :p6q3, :p6q4, :p6q5,
      :p7q1, :p7q2, :p7q3, :p7q4
    ]
    struct
    |> cast(params, fields)
  end

  def update_su_teacher_ids(changeset, su_id, teacher_id) do
    changeset
    |> put_change(:user_id, su_id)
    |> put_change(:last_updated_by, teacher_id)
  end

  # helper
  def create_question_key_combo do
    questions_sec1 = Healthlocker.ComponentView.get_options("questions_sec1")
    questions_sec2 = Healthlocker.ComponentView.get_options("questions_sec2")
    questions_sec3 = Healthlocker.ComponentView.get_options("questions_sec3")
    questions_sec4 = Healthlocker.ComponentView.get_options("questions_sec4")
    questions_sec5 = Healthlocker.ComponentView.get_options("questions_sec5")
    questions_sec6 = Healthlocker.ComponentView.get_options("questions_sec6")
    questions_sec7 = Healthlocker.ComponentView.get_options("questions_sec7")
    keys_sec1 = [:p1q1, :p1q2, :p1q3, :p1q4, :p1q5, :p1q6]
    keys_sec2 = [:p2q1, :p2q2, :p2q3]
    keys_sec3 = [:p3q1, :p3q2, :p3q3, :p3q4]
    keys_sec4 = [:p4q1, :p4q2, :p4q3, :p4q4, :p4q5, :p4q6, :p4q7, :p4q8, :p4q9, :p4q10]
    keys_sec5 = [:p5q1, :p5q2, :p5q3, :p5q4, :p5q5]
    keys_sec6 = [:p6q1, :p6q2, :p6q3, :p6q4, :p6q5]
    keys_sec7 = [:p7q1, :p7q2, :p7q3, :p7q4]
    combo1 = Enum.zip(questions_sec1, keys_sec1)
    combo2 = Enum.zip(questions_sec2, keys_sec2)
    combo3 = Enum.zip(questions_sec3, keys_sec3)
    combo4 = Enum.zip(questions_sec4, keys_sec4)
    combo5 = Enum.zip(questions_sec5, keys_sec5)
    combo6 = Enum.zip(questions_sec6, keys_sec6)
    combo7 = Enum.zip(questions_sec7, keys_sec7)

    %{
      combo1: combo1, combo2: combo2, combo3: combo3, combo4: combo4,
      combo5: combo5, combo6: combo6, combo7: combo7
    }
  end

end
