defmodule Healthlocker.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :section, :string
      add :question, :string
      add :answer, :text
      add :su_id, references(:users, on_delete: :delete_all)
      add :last_updated_by_id, references(:users)

      timestamps()
    end

    create index(:answers, [:su_id])
    create index(:answers, [:last_updated_by_id])
  end
end
