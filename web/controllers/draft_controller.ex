defmodule DraftServer.DraftController do
  use DraftServer.Web, :controller

  alias DraftServer.Draft

  plug :scrub_params, "draft" when action in [:create, :update]

  # plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "token"
  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__, typ: "token"] when action in [:create, :update, :delete, :me]

  def index(conn, _params) do
    drafts = Repo.all(Draft)
    render(conn, "index.json", drafts: drafts)
  end

  def me(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    user_id = current_user.id
    drafts = Repo.all(
          from d in Draft,
            where: d.user_id == ^user_id,
            order_by: [desc: d.inserted_at],
            select: d
        )
    render(conn, "index.json", drafts: drafts)
  end

  def create(conn, %{"draft" => draft_params}) do

    current_user = Guardian.Plug.current_resource(conn)
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
    "data/generated.json"
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

  require IEx
  def players_generator(conn, _params) do
    raw_players =
      File.read!("data/players.json")
      |> Poison.decode!

    # fantasy_players =
    #   File.read!("data/fantasy.json")
    #   |> Poison.decode!

    ultimate_positions =
      CSVLixir.read("data/ultimate.csv") |> Enum.to_list

    lists = raw_players["lists"]
    players_list = Enum.map(lists, fn x ->
      player_name = x["player"]["givenName"] <> " " <> x["player"]["surname"]
      # |> List.first
      # |> List.first
#
      position = Enum.filter(ultimate_positions, fn x -> Enum.at(x, 0) <> " " <> Enum.at(x, 1) == player_name end)
      |> List.first

      # positions = position

      # IEx.pry

      # if position != nil do
      postions = case position do
        nil -> ""
        _ ->
          position
          |> List.delete_at(0) # Remove first name
          |> List.delete_at(0) # Remove last name
          |> List.delete_at(0) # Remove team name
          |> Enum.filter(fn x -> x != "" end)
      end
      # end

      # Remove the player names and just get the positions


      # positions = List.first(position)["positions"]

      position_descriptions = %{
        1 => "Defender",
        2 => "Mid",
        3 => "Ruck",
        4 => "Forward"
      }

      # IO.puts inspect(x["player"]["givenName"])
      # IO.puts inspect(x["player"]["surname"])
      # IO.puts inspect(player_id)
      # IO.puts inspect(positions)
      # if positions != nil do
      # fantasy_replaced_positions = Enum.map(positions, fn x ->
      #
      #   # position_id = Enum.filter(position_descriptions, fn y -> x == y end)
      #   position_descriptions[x]
      #   # IEx.pry
      #   # String.replace(x, position_id, position_descriptions[position_id])
      # end)
    # end

      %{
      "givenName" => x["player"]["givenName"],
      "surname" => x["player"]["surname"],
      "photoURL" => x["player"]["photoURL"],
      "jumper" => x["player"]["jumper"],
      "playerId" => x["player"]["playerId"],
      "teamId" => x["team"]["teamId"],
      "teamAbbr" => x["team"]["teamAbbr"],
      "teamName" => x["team"]["teamName"],
      "teamNickname" => x["team"]["teamNickname"],
      # "new_player_id" => player_name,
      "positions" => postions

    } end )

    conn
    |> put_status(:ok)
    |> json(players_list)
  end


  def dashboard(conn, _params) do

  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> text('{"error":"Autentication failed."}')
  end
end
