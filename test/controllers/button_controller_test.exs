defmodule App.ButtonControllerTest do
  use App.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, button_path(conn, :index)
    assert html_response(conn, 200) =~ "button"
  end
end
