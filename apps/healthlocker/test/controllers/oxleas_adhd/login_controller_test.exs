defmodule Healthlocker.OxleasAdhd.LoginControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.User

  @su_attrs %{
    email: "service_user@gmail.com",
    password: "password"
  }

  @clinician_attrs %{
    email: "clinician@gmail.com",
    password: "password"
  }

  @super_admin_attrs %{
    email: "super_admin@gmail.com",
    password: "password"
  }

  @invalid_attrs %{
    email: "clinician@gmail.com",
    password: "wrong_password"
  }

  test "GET /", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Email"
  end

  describe "with valid data for signed up user" do
    setup do
      %User{
        id: 1234,
        first_name: "My",
        last_name: "Name",
        email: "service_user@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        role: "service_user"
      } |> Repo.insert

      %User{
        id: 1235,
        first_name: "My",
        last_name: "Name",
        email: "clinician@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician"
      } |> Repo.insert

      %User{
        id: 1236,
        first_name: "My",
        last_name: "Name",
        email: "super_admin@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "super_admin"
      } |> Repo.insert

      :ok
    end

    test "/login :: create with valid data for service user", %{conn: conn} do
      conn = post conn, login_path(conn, :create), login: @su_attrs
      assert get_flash(conn, :info) == "Welcome to Headscape Focus!"
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end

    test "/login :: create with valid data for super admin", %{conn: conn} do
      conn = post conn, login_path(conn, :create), login: @super_admin_attrs
      assert get_flash(conn, :info) == "Logged in as super admin"
      assert redirected_to(conn) == user_path(conn, :index)
    end

    test "/login :: create with valid data for clinician", %{conn: conn} do
      conn = post conn, login_path(conn, :create), login: @clinician_attrs
      assert get_flash(conn, :info) == "Logged in as clinician"
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "/login :: create with invalid data" do
      conn = post build_conn(), login_path(build_conn(), :create), login: @invalid_attrs
      assert get_flash(conn, :error) == "Invalid email/password combination"
      assert html_response(conn, 200) =~ "Email"
    end

    test "/login :: delete", %{conn: conn} do
      user = Repo.get(User, 1234)
      conn = delete conn, login_path(conn, :delete, user)
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end
end
