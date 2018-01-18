defmodule Healthlocker.Repo.Migrations.AddUpdateInfoToAboutMe do
  use Ecto.Migration

  def change do
    alter table(:about_mes) do
      add :last_updated_by, references(:users)
      add :team_last_update, :naive_datetime
      add :my_last_update, :naive_datetime
    end
  end
end
