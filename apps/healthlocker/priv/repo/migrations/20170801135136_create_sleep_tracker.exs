defmodule Healthlocker.Repo.Migrations.CreateSleepTracker do
  use Ecto.Migration

  def change do
    create table(:sleep_trackers) do
      add :hours_slept, :string, null: false
      add :wake_count, :string
      add :notes, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :for_date, :date, null: false

      timestamps()
    end
    create index(:sleep_trackers, [:user_id])

  end
end
