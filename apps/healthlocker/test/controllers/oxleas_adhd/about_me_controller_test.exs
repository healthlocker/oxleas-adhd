defmodule Healthlocker.OxleasAdhd.AboutMeControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{AboutMe, User}

  @valid_attrs %{early_life: "When I was young..."}

  describe "No user logged in" do
    test "GET users/1/about-me/new gets redirected", %{conn: conn} do
      conn = get conn, user_about_me_path(conn, :new, %User{id: 1})
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

    test "GET users/123456/about-me/new", %{conn: conn} do
      conn = get conn, user_about_me_path(conn, :new, conn.assigns.current_user)
      assert html_response(conn, 200) =~ "About"
    end

    test "POST users/123456/about-me with correct details", %{conn: conn} do
      conn = post conn, user_about_me_path(conn, :create, conn.assigns.current_user), about_me: @valid_attrs
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

    test "GET users/123456/about-me/new redirects to edit", %{conn: conn} do
      about_me = Repo.get(AboutMe, 1)
      conn = get conn, user_about_me_path(conn, :new, conn.assigns.current_user)
      assert redirected_to(conn) == user_about_me_path(conn, :edit, conn.assigns.current_user, about_me)
    end

    test "PUT users/123456/about-me/:id to update an entry", %{conn: conn} do
      about_me = Repo.get(AboutMe, 1)
      conn = put conn, user_about_me_path(conn, :update, conn.assigns.current_user, about_me), about_me: @valid_attrs
      assert redirected_to(conn) == toolkit_path(conn, :index)
    end
  end
end
