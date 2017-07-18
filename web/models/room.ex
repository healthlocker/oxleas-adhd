defmodule App.Room do
  use App.Web, :model

  schema "rooms" do
    field :name, :string
    many_to_many :users, App.User, join_through: "user_rooms", on_delete: :delete_all
    has_many :messages, App.Message

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
