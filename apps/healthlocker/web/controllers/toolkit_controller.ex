defmodule Healthlocker.ToolkitController do
  use Healthlocker.Web, :controller

  alias Healthlocker.{Repo, Post, User}

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User, user_id) |> Repo.preload(:medication)
    medication = user.medication
    coping_strategies = Post
                        |> Post.get_coping_strategies(user_id)
                        |> Repo.all
                        |> Enum.take(-3)
    conn
    |> render("index.html", coping_strategies: coping_strategies, medication: medication)
  end
end
