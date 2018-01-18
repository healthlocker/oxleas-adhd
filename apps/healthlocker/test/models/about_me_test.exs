defmodule Healthlocker.AboutMeTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{AboutMe, User}

  @valid_attrs %{
    early_life: "some content",
  }

  test "changeset with valid attributes" do
    changeset = AboutMe.changeset(%AboutMe{}, @valid_attrs)
    assert changeset.valid?
  end

  test "user_updated updates the :my_last_update key" do
    changeset =
      AboutMe.changeset(%AboutMe{}, @valid_attrs)
      |> AboutMe.user_updated

    date = NaiveDateTime.to_date(changeset.changes.my_last_update)
    assert date == Date.utc_today()
  end

  test "format_team_name returns the users full name and job role" do
    %User{
      id: 123456,
      first_name: "first",
      last_name: "last",
      job_role: "job",
      email: "test@email.com",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password")
    } |> Repo.insert

    user = Repo.get(User, 123456)
    name = AboutMe.format_team_name(user)
    assert name == "[ first last, job ]"
  end

  test "format_naive_date returns a string of date" do
    date_time_str = AboutMe.format_naive_date(~N[2018-01-17 10:07:04.400277])
    assert date_time_str == "[ 17/01/2018 ][ 10:07 ]"
  end
end
