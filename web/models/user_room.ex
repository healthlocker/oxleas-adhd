defmodule App.UserRoom do
  use App.Web, :model

  schema "user_rooms" do
    belongs_to :user, App.User
    belongs_to :room, App.Room

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id, name: :user_rooms_user_id_room_id_index)
  end
end
