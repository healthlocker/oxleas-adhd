defmodule Healthlocker.OxleasAdhd.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  @su_attrs %{
    first_name: "SU",
    last_name: "SU",
    dob: "01/01/1989",
    email: "su@mail.com",
    password: "password",
    user_type: "new_service_user"
  }
  @carer_attrs %{
    first_name: "Carer",
    last_name: "Carer",
    relationship: "Parent",
    email: "carer@mail.com",
    password: "password",
    user_type: "new_carer"
  }
  @staff_attrs %{
    first_name: "Staff",
    last_name: "Staff",
    job_role: "Clinician",
    email: "staff@mail.com",
    password: "password",
    user_type: "new_staff"
  }

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

  describe "super-admin can access user routes" do
    setup %{} do
      user = %User{
        id: 1234,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "super_admin"
      } |> Repo.insert!

      %User{
        first_name: "test",
        last_name: "test",
        job_role: "clinician",
        email: "test@example.com",
        password: "password"
      } |> Repo.insert!

      {:ok, conn: build_conn() |> assign(:current_user, user)}
    end

    test "GET index", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Accounts"
    end

    test "GET new for service user", %{conn: conn} do
      conn = get conn, user_path(conn, :new), user_type: "new_service_user"
      assert html_response(conn, 200) =~ "Add service user"
    end

    test "GET new for staff", %{conn: conn} do
      conn = get conn, user_path(conn, :new), user_type: "new_staff"
      assert html_response(conn, 200) =~ "Add staff"
    end

    test "GET new for carer", %{conn: conn} do
      conn = get conn, user_path(conn, :new), user_type: "new_carer"
      assert html_response(conn, 200) =~ "Add carer"
    end

    test "POST create for service_user", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @su_attrs
      user = Repo.get_by(User, email: "su@mail.com")
      assert user
      assert redirected_to(conn) == user_clinician_path(conn, :new, user)
      assert get_flash(conn, :info) == "Please pick the care team for this user"
    end

    test "POST create for carer", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @carer_attrs
      user = Repo.get_by(User, email: "carer@mail.com")
      assert user
      assert redirected_to(conn) == user_carer_path(conn, :new, user)
      assert get_flash(conn, :info) == "Please enter the service user this carer should connect to"
    end

    test "POST create for staff", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @staff_attrs
      user = Repo.get_by(User, email: "staff@mail.com")
      assert user
      assert redirected_to(conn) == user_path(conn, :index)
      assert get_flash(conn, :info) == "User created successfully"
    end

    test "GET edit service user", %{conn: conn} do
      user = %User{
        first_name: "SU",
        last_name: "SU",
        dob: "01/01/1989",
        email: "su@mail.com",
        password: "password",
      } |> Repo.insert!
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Add service user"
    end

    test "cannot enter staff with invalid attributes", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200)
      assert get_flash(conn, :error) == "User could not be created"
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
