defmodule OxleasAdhd.Repo.Migrations.CreateDiary do
  use Ecto.Migration

  def change do
    create table(:diaries) do
      add :entry, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
