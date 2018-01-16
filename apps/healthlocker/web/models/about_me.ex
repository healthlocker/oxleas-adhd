defmodule Healthlocker.AboutMe do
  use Healthlocker.Web, :model

  schema "about_mes" do
    field :early_life, :string
    field :health, :string
    field :events, :string
    field :hobbies, :string
    field :school, :string
    field :important_people, :string
    field :difficulties, :string
    field :strengths, :string
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:early_life, :health, :events, :hobbies, :school, :important_people, :difficulties, :strengths])
  end
end
