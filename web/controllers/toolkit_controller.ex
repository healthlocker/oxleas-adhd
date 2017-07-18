defmodule App.ToolkitController do
  use App.Web, :controller

  alias App.Post

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    coping_strategies = Post
                        |> Post.get_coping_strategies(user_id)
                        |> Repo.all
                        |> Enum.take(-3)
    render conn, "index.html", coping_strategies: coping_strategies
  end
end
