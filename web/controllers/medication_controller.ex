defmodule OxleasAdhd.MedicationController do
  use OxleasAdhd.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, params) do
    conn
    |> render("new.html")
  end

  def edit(conn, params) do
    conn
    |> render("edit.html")
  end
end
