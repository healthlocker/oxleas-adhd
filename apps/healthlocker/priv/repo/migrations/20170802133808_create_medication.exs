defmodule Healthlocker.Repo.Migrations.CreateMedication do
  use Ecto.Migration

  def change do
    create table(:medications) do
      add :name, :text
      add :dosage, :text
      add :frequency, :text
      add :other_medicine, :text
      add :allergies, :text
      add :past_medication, :text
      add :user_id, references(:users)

      timestamps()
    end
  end
end
