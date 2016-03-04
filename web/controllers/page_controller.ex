defmodule DraftServer.PageController do
  use DraftServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def dashboard(conn, _params) do
    conn
    |> put_layout(false)
    |> render("dashboard.html")
  end
end
