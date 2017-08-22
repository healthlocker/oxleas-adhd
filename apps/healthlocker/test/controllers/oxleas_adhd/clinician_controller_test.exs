defmodule Healthlocker.OxleasAdhd.ClinicianControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{User, Room}

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

    user2 = %User{
      id: 1237,
      first_name: "test",
      last_name: "test",
      role: "service_user",
      email: "service_user@example.com",
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

    admin = %User{
      id: 1238,
      email: "super@admin.com",
      role: "super_admin"
    } |> Repo.insert!

    %Room{
      name: "service-user-care-team:1237"
    } |> Repo.insert!

    {:ok, user: user, user2: user2, conn: build_conn() |> assign(:current_user, admin)}
  end

  test "GET /new renders new.html", %{conn: conn, user: user} do
    conn = get conn, user_clinician_path(conn, :new, user)
    assert html_response(conn, 200) =~ "Connect to staff"
  end

  test "GET :edit renders edit.html", %{conn: conn, user: user} do
    conn = get conn, user_clinician_path(conn, :edit, user, "1")
    assert html_response(conn, 200) =~ "Edit Service User"
  end

  test "PUT /update with valid attributes", %{conn: conn, user2: user2} do
    conn = put conn, user_clinician_path(conn, :update, user2, "1"), clinician: @valid_attrs
    assert redirected_to(conn, 302) =~ user_path(conn, :index)
    assert get_flash(conn, :info) == "Staff updated"
  end

  test "POST /create with valid attributes", %{conn: conn, user: user} do
    conn = post conn, user_clinician_path(conn, :create, user), clinician: @valid_attrs
    assert redirected_to(conn, 302) =~ user_path(conn, :index)
    assert get_flash(conn, :info) == "Staff connected"
  end
end
