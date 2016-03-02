defmodule DraftServer.DraftView do
  use DraftServer.Web, :view

  def render("index.json", %{drafts: drafts}) do
    %{data: render_many(drafts, DraftServer.DraftView, "draft.json")}
  end

  def render("show.json", %{draft: draft}) do
    %{data: render_one(draft, DraftServer.DraftView, "draft.json")}
  end

  def render("draft.json", %{draft: draft}) do
    %{id: draft.id,
      user_id: draft.user_id,
      player_id: draft.player_id,
      position: draft.position}
  end
end
