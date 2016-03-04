defmodule DraftServer.UserView do
  use DraftServer.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, DraftServer.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, DraftServer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
end
