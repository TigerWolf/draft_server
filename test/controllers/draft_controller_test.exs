defmodule DraftServer.DraftControllerTest do
  use DraftServer.ConnCase

  alias DraftServer.Draft
  @valid_attrs %{player_id: "some content", position: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, draft_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    draft = Repo.insert! %Draft{}
    conn = get conn, draft_path(conn, :show, draft)
    assert json_response(conn, 200)["data"] == %{"id" => draft.id,
      "user_id" => draft.user_id,
      "player_id" => draft.player_id,
      "position" => draft.position}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, draft_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, draft_path(conn, :create), draft: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Draft, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, draft_path(conn, :create), draft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    draft = Repo.insert! %Draft{}
    conn = put conn, draft_path(conn, :update, draft), draft: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Draft, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    draft = Repo.insert! %Draft{}
    conn = put conn, draft_path(conn, :update, draft), draft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    draft = Repo.insert! %Draft{}
    conn = delete conn, draft_path(conn, :delete, draft)
    assert response(conn, 204)
    refute Repo.get(Draft, draft.id)
  end
end
