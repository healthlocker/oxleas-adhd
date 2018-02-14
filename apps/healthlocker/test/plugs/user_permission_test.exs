defmodule Healthlocker.Plugs.RequireCorrectUserTest do
  use Healthlocker.ConnCase
  alias Healthlocker.Plugs.RequireCorrectUser
  alias Healthlocker.{User}

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Healthlocker.Router, :browser)
      |> get("/")

    {:ok, su} = %User{
      id: 1234,
      email: "service@email.com",
      role: "slam_user"
    } |> Repo.insert

    {:ok, teacher} = %User{
      id: 3456,
      email: "teacher@email.com",
      role: "teacher"
    } |> Repo.insert

    {:ok, conn: conn, su: su, teacher: teacher}

  end

  test "user is redirected when current_user does not equal user_id", %{conn: conn} do
    conn = conn |> authenticate |> RequireCorrectUser.redirect_to_home("1")
    assert redirected_to(conn) == "/"
  end

  test "user passes through when current_user is assigned", %{conn: conn, su: su} do
    conn = conn |> assign(:current_user, su) |> RequireCorrectUser.redirect_to_home(1234)
    assert not_redirected?(conn)
  end

  test "teacher cannot access service user they are not assiged to", %{conn: conn, teacher: teacher} do
    conn = conn |> assign(:current_user, teacher) |> RequireCorrectUser.redirect_to_home(1234)
    assert get_flash(conn, :error) == "You cannot access that page"
    assert conn.status == 302
  end

  defp authenticate(conn) do
    conn |> assign(:current_user, %Healthlocker.User{})
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end
end
