defmodule OxleasAdhd.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :job_role, :string
    end
  end
end
