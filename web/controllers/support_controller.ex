defmodule App.SupportController do
  use App.Web, :controller
  import App.Plugs.FindRoom
  plug :find_room

  def index(conn, _params) do
    render conn, "index.html"
  end
end
