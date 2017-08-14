defmodule Healthlocker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :security_question, :string
      add :security_answer, :string
      add :data_access, :boolean
      add :role, :string
      add :phone_number, :string
      add :slam_id, :integer
      add :first_name, :string
      add :last_name, :string
      add :reset_password_token, :string
      add :reset_token_sent_at, :utc_datetime
      add :c4c, :boolean
      add :comms_consent, :boolean

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
