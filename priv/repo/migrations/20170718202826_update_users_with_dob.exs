defmodule App.Repo.Migrations.UpdateUsersWithDob do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :dob, :date
    end
  end
end
