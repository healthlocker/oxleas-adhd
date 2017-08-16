defmodule Healthlocker.OxleasAdhd.AccountControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User

  @valid_attrs %{
    first_name: "My",
    last_name: "Name",
    security_check: "Answer",
    security_question: "?",
    security_answer: "yes",
    password_check: "password",
    password: "New password",
    password_confirmation: "New password"
  }
  @invalid_attrs %{
    first_name: "",
    last_name: "",
    email: "a",
    phone_number: "",
    security_check: "Answer",
    security_question: "",
    security_answer: "",
    password_check: "password",
    password: 1
  }
  @wrong_password %{
    password_check: "Wrong password",
    password: "New password",
    password_confirmation: "New password"
  }
  @wrong_confirmation %{
    password_check: "password",
    password: "New password",
    password_confirmation: "not new password"
  }

  describe "current_user is assigned in the session" do
    setup do
      %User{
        id: 123_456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        data_access: false,
        c4c: false,
        comms_consent: false
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123_456)) }
    end

    test "renders index.html", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert html_response(conn, 200) =~ "Account"
    end

    test "update user with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @valid_attrs
      assert redirected_to(conn) == account_path(conn, :index)
    end

    test "does not update user when data is invalid", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Account"
    end

    test "renders consent.html on /account/consent", %{conn: conn} do
      conn = get conn, account_path(conn, :consent)
      assert html_response(conn, 200) =~ "anonymous data"
    end

    test "updates user data_access with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update_consent), user: %{
        data_access: true,
        c4c: true,
        comms_consent: true
      }
      assert redirected_to(conn) == account_path(conn, :consent)
    end

    test "render edit_password.html", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_password)
      assert html_response(conn, 200) =~ "Current password"
    end

    test "does not update when current password is incorrect", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @wrong_password
      assert html_response(conn, 200) =~ "Current password"
      assert get_flash(conn, :error) == "Incorrect current password"
    end

    test "updates password with valid data", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @valid_attrs
      assert redirected_to(conn) == account_path(conn, :edit_password)
      refute get_flash(conn, :error) == "Incorrect current password"
    end

    test "does not update password when data is invalid", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Current password"
    end

    test "does not update password when confirmation does not match", %{conn: conn} do
      conn = put conn, account_path(conn, :update_password), user: @wrong_confirmation
      assert html_response(conn, 200) =~ "Current password"
    end
  end

  describe "current_user is not assigned in the session" do
    test "index is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update is redirected and conn halted", %{conn: conn} do
      conn = put conn, account_path(conn, :update), user: @valid_attrs
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "consent is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :consent)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update_consent is redirected and conn halted", %{conn: conn} do
      conn = put conn, account_path(conn, :update_consent), user: %{data_access: true}
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "edit_password is redirected and conn halted", %{conn: conn} do
      conn = get conn, account_path(conn, :edit_password)
      assert html_response(conn, 302)
      assert conn.halted
    end

    test "update_password is redirected and conn halted", %{conn: conn} do
       conn = put conn, account_path(conn, :update_password)
       assert html_response(conn, 302)
       assert conn.halted
    end
  end
end
