defmodule OxleasAdhd.UserControllerTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.User

  @in_db %{
    user_type: "new_staff",
    first_name: "test",
    last_name: "test",
    job_role: "clinician",
    email: "test@example.com",
    password: "password"
  }

  @staff_not_in %{
    user_type: "new_staff",
    first_name: "not",
    last_name: "there",
    job_role: "clinician",
    email: "not_in@example.com",
    password: "password"
  }

  @carer_not_in %{
    user_type: "new_carer",
    first_name: "not",
    last_name: "there",
    relationship: "parent",
    email: "not_in@example.com",
    password: "password"
  }

  @invalid_attrs %{
    user_type: "new_staff"
  }

  setup %{} do
    %User{
      first_name: "test",
      last_name: "test",
      job_role: "clinician",
      email: "test@example.com",
      password: "password"
    } |> Repo.insert!

    %User{
      first_name: "test",
      last_name: "test",
      relationship: "parent",
      email: "carer@example.com",
      password: "password"
    } |> Repo.insert!

    :ok
  end

  describe "endpoints in super_admin/users work as expected with logged in user" do
    # user is not currently logged in as log in functionality is not built
    # however plug has been build that will not let the user access page unless
    # correct user is logged in. Will update test setup with this when log in
    # feature is built and plug is included in the router

    test "GET /super-admin/users", %{conn: conn} do
      conn = get conn, "/super-admin/users"
      assert html_response(conn, 200)
    end

    test "GET /super-admin/users/new for staff", %{conn: conn} do
      conn = get conn, "/super-admin/users/new?user_type=new_staff"
      assert html_response(conn, 200)
    end

    test "can enter staff that is not currently in the db", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @staff_not_in
      user = Repo.get_by(User, email: "not_in@example.com")
      assert redirected_to(conn) == user_path(conn, :index)
      assert user
    end

    test "cannot enter a user that is already in the db", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @in_db
      assert html_response(conn, 200)
      assert get_flash(conn, :error) == "User could not be created"
    end

    test "cannot enter staff with invalid attributes", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200)
      assert get_flash(conn, :error) == "User could not be created"
    end

    test "GET /super-admin/users/new for carer", %{conn: conn} do
      conn = get conn, "/super-admin/users/new?user_type=new_carer"
      assert html_response(conn, 200)
    end

    test "can enter carer that is not currently in the db", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @carer_not_in
      user = Repo.get_by(User, email: "not_in@example.com")
      assert redirected_to(conn) == user_carer_path(conn, :new, user)
      assert user
    end

    test "cannot enter a carer that is already in the db", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @in_db
      assert html_response(conn, 200)
      assert get_flash(conn, :error) == "User could not be created"
    end
  end
end