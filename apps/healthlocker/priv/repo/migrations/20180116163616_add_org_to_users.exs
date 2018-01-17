defmodule Healthlocker.Repo.Migrations.AddOrgToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :org, :string
    end
  end
end
