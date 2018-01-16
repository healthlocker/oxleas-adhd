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
    field :last_updated_by, :integer
    field :team_last_update, :naive_datetime
    field :my_last_update, :naive_datetime
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:early_life, :health, :events, :hobbies, :school, :important_people, :difficulties, :strengths])
  end

  def user_updated(changeset) do
    changeset
    |> put_change(:my_last_update, NaiveDateTime.utc_now())
  end

  def team_updated(changeset, user_id) do
    changeset
    |> put_change(:last_updated_by, user_id)
    |> put_change(:my_last_update, NaiveDateTime.utc_now())
  end
end
# NaiveDateTime.utc_now()
