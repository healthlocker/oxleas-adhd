defmodule OxleasAdhd.Repo.Migrations.CreateSymptomTracker do
  use Ecto.Migration

  def change do
    create table(:symptom_trackers) do
      add :affected_scale, :string
      add :notes, :text
      add :symptom_id, references(:symptoms, on_delete: :delete_all)

      timestamps()
    end
  end
end
