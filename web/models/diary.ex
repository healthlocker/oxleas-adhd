defmodule App.Diary do
  use App.Web, :model

  schema "diaries" do
    field :entry, :string, null: false
    belongs_to :user, App.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:entry])
    |> validate_required([:entry])
  end
end
