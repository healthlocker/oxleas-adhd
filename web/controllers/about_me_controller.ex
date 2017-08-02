defmodule OxleasAdhd.AboutMeController do
  use OxleasAdhd.Web, :controller

  def new(conn, params) do
    conn
    |> render("new.html")
  end

  def edit(conn, params) do
    conn
    |> render("edit.html")
  end
end
