defmodule Healthlocker.OxleasAdhd.AboutMeController do
  use Healthlocker.Web, :controller

  def new(conn, params) do
    conn
    |> render("new.html")
  end

  def edit(conn, params) do
    conn
    |> render("edit.html")
  end
end
