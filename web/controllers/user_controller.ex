defmodule OxleasAdhd.UserController do
  use OxleasAdhd.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
