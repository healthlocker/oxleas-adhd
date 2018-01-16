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

  # helper functions
  def format_staff_update_info(about_me, user) do
    case about_me.last_updated_by do
      nil ->
        "No one from your team has updated your about me yet"
      _   ->
        team_name_str = format_team_name(user)
        date_time_str = format_naive_date(about_me.my_last_update)
        "#{team_name_str} #{date_time_str}"
    end
  end

  def format_team_name(user) do
    "[ #{user.first_name} #{user.last_name}, #{user.job_role} ]"
  end

  def format_naive_date(naive_date) do
    {{year, month, day}, {hour, minute, _}} = NaiveDateTime.to_erl(naive_date)
    [y, m, d, h, min] =
      [year, month, day, hour, minute]
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(fn str ->
        if String.length(str) == 1, do: "0" <> str, else: str
      end)
    "[ #{d}/#{m}/#{y} ][ #{h}:#{min} ]"
  end
end
