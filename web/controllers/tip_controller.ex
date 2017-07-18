defmodule App.TipController do
  use App.Web, :controller

  alias App.Post

  def index(conn, params) do
    tips = if params["tag"] do
            Post |> Post.find_tags(params) |> Repo.all
          else
            Post |> Post.find_tips |> Repo.all
          end
    render(conn, "index.html", posts: tips)
  end

end
