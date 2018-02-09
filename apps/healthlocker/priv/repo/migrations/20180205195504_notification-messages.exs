defmodule :"Elixir.Healthlocker.Repo.Migrations.Notification-messages" do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :unread, :boolean, default: false
    end
  end
end
