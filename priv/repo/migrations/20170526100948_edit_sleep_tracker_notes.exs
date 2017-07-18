defmodule App.Repo.Migrations.EditSleepTrackerNotes do
  use Ecto.Migration

  def change do
    alter table(:sleep_trackers) do
      modify :notes, :text
    end
  end
end
