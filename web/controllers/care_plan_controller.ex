defmodule App.CarePlanController do
  use App.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
