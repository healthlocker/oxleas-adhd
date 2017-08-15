defmodule ClinicianQueryTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.{User, Clinician, ClinicianQuery}

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

    %Clinician{
      clinician_id: 1235,
      caring_id: 1234
    } |> Repo.insert!

    :ok
  end

  test "get_by_user_id returns the correct rows by caring id" do
    actual = Clinician
      |> ClinicianQuery.get_by_user_id(1234)
      |> Repo.all
    [head | _] = actual
    assert head.clinician_id == 1235
    assert head.caring_id == 1234
  end

  test "get_by_user_id returns incorrect result with clinician_id" do
    actual = Clinician
      |> ClinicianQuery.get_by_user_id(1235)
      |> Repo.all
    assert actual == []
  end
end
