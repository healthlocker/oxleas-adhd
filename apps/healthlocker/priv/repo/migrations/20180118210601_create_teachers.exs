defmodule Healthlocker.Repo.Migrations.CreateTeachers do
  use Ecto.Migration

  def change do
    create table(:teachers, primary_key: false) do
      add :teacher_id, references(:users), null: false
      add :caring_id, references(:users), null: false
    end

    create index(:teachers, [:teacher_id])
    create index(:teachers, [:caring_id])
  end
end
