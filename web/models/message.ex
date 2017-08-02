defmodule OxleasAdhd.Message do
  use OxleasAdhd.Web, :model

  schema "messages" do
    field :body, :string
    field :name, :string
    belongs_to :user, OxleasAdhd.User
    belongs_to :room, OxleasAdhd.Room

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :user_id, :room_id])
    |> validate_required([:body, :user_id, :room_id])
  end
end
