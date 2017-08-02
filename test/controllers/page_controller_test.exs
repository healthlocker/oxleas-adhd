defmodule OxleasAdhd.PageControllerTest do
  use OxleasAdhd.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Get Started"
  end
end
