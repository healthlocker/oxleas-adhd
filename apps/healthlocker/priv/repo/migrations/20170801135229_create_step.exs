defmodule Healthlocker.Repo.Migrations.CreateStep do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :goal_id, references(:goals)
      add :details, :string
      add :complete, :boolean

      timestamps()
    end
  end
end
