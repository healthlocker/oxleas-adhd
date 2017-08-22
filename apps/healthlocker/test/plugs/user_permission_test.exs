defmodule Healthlocker.Plugs.RequireCorrectUserTest do
  use Healthlocker.ConnCase
  alias Healthlocker.Plugs.RequireCorrectUser

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Healthlocker.Router, :browser)
      |> get("/")

    {:ok, conn: conn}
  end

  test "user is redirected when current_user does not equal user_id", %{conn: conn} do
    conn = conn |> authenticate |> RequireCorrectUser.redirect_to_home("1")
    assert redirected_to(conn) == "/"
  end

  test "user passes through when current_user is assigned", %{conn: conn} do
    conn = conn |> authenticate |> RequireCorrectUser.redirect_to_home(nil)
    assert not_redirected?(conn)
  end

  defp authenticate(conn) do
    conn |> assign(:current_user, %Healthlocker.User{})
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end
end
