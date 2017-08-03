defmodule OxleasAdhd.Repo.Migrations.CreateClinicians do
  use Ecto.Migration

  def change do
    create table(:clinicians, primary_key: false) do
      add :clinician_id, references(:users), null: false
      add :caring_id, references(:users), null: false
    end

    create index(:clinicians, [:clinician_id])
    create index(:clinicians, [:caring_id])
  end
end
