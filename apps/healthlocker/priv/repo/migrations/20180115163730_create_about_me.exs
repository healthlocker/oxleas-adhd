defmodule Healthlocker.Repo.Migrations.CreateAboutMe do
  use Ecto.Migration

  def change do
    create table(:about_mes) do
      add :early_life, :text
      add :health, :text
      add :events, :text
      add :hobbies, :text
      add :school, :text
      add :important_people, :text
      add :difficulties, :text
      add :strengths, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
