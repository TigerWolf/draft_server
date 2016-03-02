defmodule DraftServer.DraftController do
  use DraftServer.Web, :controller

  alias DraftServer.Draft

  plug :scrub_params, "draft" when action in [:create, :update]

  # plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "token"
  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__, typ: "token"] when action in [:create, :update, :delete]

  def index(conn, _params) do
    drafts = Repo.all(Draft)
    render(conn, "index.json", drafts: drafts)
  end

  def create(conn, %{"draft" => draft_params}) do

    current_user = Guardian.Plug.current_resource(conn)
    IO.puts current_user.id
    draft_params = Map.put(draft_params, "user_id", current_user.id)

    changeset = Draft.changeset(%Draft{}, draft_params)

    case Repo.insert(changeset) do
      {:ok, draft} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", draft_path(conn, :show, draft))
        |> render("show.json", draft: draft)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DraftServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    draft = Repo.get!(Draft, id)
    render(conn, "show.json", draft: draft)
  end

  def update(conn, %{"id" => id, "draft" => draft_params}) do
    draft = Repo.get!(Draft, id)
    changeset = Draft.changeset(draft, draft_params)

    case Repo.update(changeset) do
      {:ok, draft} ->
        render(conn, "show.json", draft: draft)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DraftServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    draft = Repo.get!(Draft, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(draft)

    send_resp(conn, :no_content, "")
  end

  @mock_data (
    "data/players.json"
    |> File.read!
    |> Poison.decode!
  )

  def players(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(@mock_data)
  end

  # Testing method for getting the current user
  def playersZ(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> text("#{current_user}")
  end

  def dashboard(conn, _params) do
    
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> text('{"error":"Autentication failed."}')
  end
end
