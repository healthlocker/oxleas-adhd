defmodule OxleasAdhd.Repo.Migrations.CreateGoal do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :content, :string, null: false
      add :completed, :boolean
      add :notes, :text
      add :user_id, references(:users)
      add :important, :boolean
      add :achieved_at, :date

      timestamps()
    end
  end
end
