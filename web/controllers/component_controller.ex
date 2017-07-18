defmodule App.ComponentController do
  use App.Web, :controller
  alias App.Post

  def index(conn, _params) do
    post = Post |> first |> Repo.one
    render conn, "index.html", post: post
  end
end
