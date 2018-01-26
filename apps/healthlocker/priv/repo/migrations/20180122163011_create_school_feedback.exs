defmodule Healthlocker.Repo.Migrations.CreateSchoolFeedback do
  use Ecto.Migration

  def change do
    create table(:school_feedbacks) do
      add :p1q1, :string
      add :p1q2, :string
      add :p1q3, :string
      add :p1q4, :string
      add :p1q5, :string
      add :p1q6, :string
      add :p2q1, :string
      add :p2q2, :string
      add :p2q3, :string
      add :p3q1, :string
      add :p3q2, :string
      add :p3q3, :string
      add :p3q4, :string
      add :p4q1, :string
      add :p4q2, :string
      add :p4q3, :string
      add :p4q4, :string
      add :p4q5, :string
      add :p4q6, :string
      add :p4q7, :string
      add :p4q8, :string
      add :p4q9, :string
      add :p4q10, :string
      add :p5q1, :text
      add :p5q2, :text
      add :p5q3, :text
      add :p5q4, :text
      add :p5q5, :text
      add :p6q1, :text
      add :p6q2, :text
      add :p6q3, :text
      add :p6q4, :text
      add :p6q5, :text
      add :p7q1, :text
      add :p7q2, :text
      add :p7q3, :text
      add :p7q4, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :last_updated_by, references(:users)

      timestamps()
    end
  end
end
