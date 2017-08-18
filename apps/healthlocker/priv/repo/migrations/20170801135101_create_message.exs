defmodule Healthlocker.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text, null: false
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:messages, [:user_id])
    create index(:messages, [:room_id])

  end
end
