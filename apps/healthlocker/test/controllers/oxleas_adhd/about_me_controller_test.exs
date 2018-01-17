defmodule Healthlocker.AboutMeControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{AboutMe, User}

  @valid_attrs %{early_life: "When I was young..."}

  describe "No user logged in" do
    test "GET /about-me/new gets redirected", %{conn: conn} do
      conn = get conn, about_me_path(conn, :new)
      assert html_response(conn, 302)
    end
  end

  describe "Current user is assigned to the conn" do
    setup do
      %User{
        id: 123456,
        first_name: "first",
        last_name: "last",
        email: "test@email.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /about-me/new", %{conn: conn} do
      conn = get conn, about_me_path(conn, :new)
      assert html_response(conn, 200) =~ "About"
    end

    test "POST /about-me with correct details", %{conn: conn} do
      conn = post conn, about_me_path(conn, :create), about_me: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end
  end

  describe "Current user assigned to the conn and About Me has been created already" do
    setup do
      %User{
        id: 123456,
        first_name: "first",
        last_name: "last",
        email: "test@email.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password")
      } |> Repo.insert
      %AboutMe{
        id: 1,
        early_life: "something",
        user_id: 123456
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123456)) }
    end

    test "GET /about-me/new redirects to edit", %{conn: conn} do
      about_me = Repo.get(AboutMe, 1)
      conn = get conn, about_me_path(conn, :new)
      assert redirected_to(conn) == about_me_path(conn, :edit, about_me)
    end

    test "PUT /about-me/:id to update an entry", %{conn: conn} do
      about_me = Repo.get(AboutMe, 1)
      conn = put conn, about_me_path(conn, :update, about_me), about_me: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end
  end
end
