defmodule Healthlocker.Repo.Migrations.AddDobToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :dob, :string
    end
  end
end
