defmodule OxleasAdhd.Repo.Migrations.AddRelationshipToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :relationship, :string
    end
  end
end
