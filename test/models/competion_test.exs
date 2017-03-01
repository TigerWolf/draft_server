defmodule DraftServer.CompetionTest do
  use DraftServer.ModelCase

  alias DraftServer.Competion

  @valid_attrs %{code: "some content", name: "some content", round: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Competion.changeset(%Competion{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Competion.changeset(%Competion{}, @invalid_attrs)
    refute changeset.valid?
  end
end
