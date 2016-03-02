defmodule DraftServer.PageController do
  use DraftServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
