defmodule Healthlocker.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text , null: false
      add :user_id, references(:users)

      timestamps()
    end
  end
end
