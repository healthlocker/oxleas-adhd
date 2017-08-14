defmodule UserQueryTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.{User, UserQuery}

  setup %{} do
    %User{
      id: 1234,
      first_name: "test",
      last_name: "test",
      role: "service_user",
      email: "test@example.com",
      password: "password"
    } |> Repo.insert!

    %User{
      id: 1235,
      first_name: "test",
      last_name: "test",
      role: "clinician",
      email: "clinician1@example.com",
      password: "password"
    } |> Repo.insert!

    %User{
      id: 1236,
      first_name: "test",
      last_name: "test",
      role: "clinician",
      email: "clinician2@example.com",
      password: "password"
    } |> Repo.insert!

    %User{
      id: 1237,
      first_name: "test",
      last_name: "test",
      dob: "01/01/2000",
      email: "su@example.com",
      password: "password"
    } |> Repo.insert!

    :ok
  end

  test "get_by_user_type returns all users of same user type" do
    actual = User
            |> UserQuery.get_by_user_type("clinician")
            |> Repo.all
            |> Enum.map(fn(user) -> user.id end)
    expected = [1235, 1236]
    assert actual == expected
  end

  test "get_by_user_type does not return users of any other role" do
    actual = User
            |> UserQuery.get_by_user_type("clinician")
            |> Repo.all
            |> Enum.map(fn(user) -> user.id end)
    expected = [1234]
    refute actual == expected
  end

  test "get_user_by_details returns user" do
    map = %{"su_dob" => "01/01/2000", "su_first_name" => "test", "su_last_name" => "test"}
    actual =
      User
      |> UserQuery.get_user_by_details(map)
      |> Repo.one()

    expected =
      User
      |> Repo.get(1237)

    assert actual == expected
  end
end