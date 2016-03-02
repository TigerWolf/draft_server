defmodule DraftServer.DraftTest do
  use DraftServer.ModelCase

  alias DraftServer.Draft

  @valid_attrs %{player_id: "some content", position: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Draft.changeset(%Draft{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Draft.changeset(%Draft{}, @invalid_attrs)
    refute changeset.valid?
  end
end
