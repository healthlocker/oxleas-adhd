defmodule App.Repo.Migrations.CreateClinicians do
  use Ecto.Migration

  def change do
    create table(:clinicians, primary_key: false) do
      add :caring_id, references(:users), null: false
      add :clinician_id, references(:users), null: false
    end

    create index(:clinicians, [:caring_id])
    create index(:clinicians, [:clinician_id])
    create unique_index(:clinicians, [:caring_id, :clinician_id])
  end
end
