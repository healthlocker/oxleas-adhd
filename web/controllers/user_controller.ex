defmodule OxleasAdhd.UserController do
  use OxleasAdhd.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, %{"user_type" => user_type}) do
    conn
    |> render(String.to_atom(user_type))
  end

  # def create(conn, params) do
  #   conn
  #   |> redirect()
  # end
end
