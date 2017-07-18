defmodule App.SupportControllerTest do
  use App.ConnCase

  test "GET /support", %{conn: conn} do
    conn = get conn, "/support"
    assert html_response(conn, 200) =~ "Get support"
  end
end
