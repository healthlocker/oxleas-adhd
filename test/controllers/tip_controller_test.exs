defmodule App.TipControllerTest do
  use App.ConnCase

  test "successfully loads tips index", %{conn: conn} do
    conn = get conn, tip_path(conn, :index)
    assert html_response(conn, 200) =~ "Tips"
  end
end
