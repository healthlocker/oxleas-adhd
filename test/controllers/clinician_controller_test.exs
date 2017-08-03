defmodule OxleasAdhd.ClinicianControllerTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.User

  @valid_attrs %{
    clin1235: "1235",
    clin1236: "false"
  }

  setup %{} do
    user = %User{
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

    {:ok, user: user}
  end

  test "GET /new renders new.html", %{conn: conn, user: user} do
    conn = get conn, user_clinician_path(conn, :new, user)
    assert html_response(conn, 200) =~ "Connect to staff"
  end

  test "POST /create with valid attributes", %{conn: conn, user: user} do
    conn = post conn, user_clinician_path(conn, :create, user), clinician: @valid_attrs
    assert redirected_to(conn, 302) =~ user_path(conn, :index)
  end
end
