defmodule DraftServer.DraftController do
  use DraftServer.Web, :controller

  alias DraftServer.Draft

  plug :scrub_params, "draft" when action in [:create, :update]

  # plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "token"
  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__, typ: "token"] when action in [:create, :update, :delete, :me]

  @mock_data (
    "data/generated.json"
    |> File.read!
    |> Poison.decode!
  )

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
    draft_params = Map.put(draft_params, "round", 1)
    draft_params = Map.put(draft_params, "competition_id", 1)

    changeset = Draft.changeset(%Draft{}, draft_params)

    case Repo.insert(changeset) do
      {:ok, draft} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", draft_path(conn, :show, draft))
        |> render("show.json", draft: draft)
        # ensure all other clients update their list
        # TODO: Add next player in list here as new item
        # DraftServer.Endpoint.broadcast "rooms:lobby", "new:msg", %{user: "#{current_user.username}", body: "player_picked #{draft_params["player_id"]}"}


        player = Enum.filter(@mock_data, fn x -> x["playerId"] == draft_params["player_id"] end) |> List.first
        next_pick = next_pick(current_user)
        message = "notification #{current_user.username} picked #{player["givenName"]} #{player["surname"]}. Next pick: #{next_pick}"
        # TODO - check for failure
        message_changeset = DraftServer.Message.changeset(%DraftServer.Message{}, %{text: message, user: "#{current_user.username}"})
        Repo.insert(message_changeset)
        DraftServer.Endpoint.broadcast "rooms:lobby", "new:msg", %{user: "#{current_user.username}", body: message}
        # TODO: save this message to database
        DraftServer.Endpoint.broadcast "rooms:lobby", "new:msg", %{user: "SYSTEM", body: "refresh_list"}
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DraftServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def message(conn, _) do
    message = Repo.one(
      from m in DraftServer.Message,
        order_by: [desc: m.inserted_at],
        limit: 1
    )

    conn
    |> put_status(:ok)
    |> json(%{message: "#{message.text}"})
  end

  def next_pick(user) do
    competition = Repo.one(
        from c in DraftServer.Competition,
          where: c.id == ^1,
          select: c
      )
    current_turn = user.turn
    next_turn = current_turn
    require Integer
    IO.puts current_turn
    if Integer.is_odd(competition.round) do
      IO.puts " ------------ ODD"
      next_turn = current_turn + 1
    else
      IO.puts " ------------ EVEN"
      next_turn = current_turn - 1
    end
    IO.puts next_turn
    next_user = Repo.one(
          from u in DraftServer.User,
            where: u.turn == ^next_turn,
            select: u
        )
    if next_user == nil do
      # increment next round
      next_round = competition.round + 1
      changeset = DraftServer.Competition.changeset(competition, %{round: next_round})
      Repo.update(changeset)
      next_user = user # This could be done differently - maybe recoursively?
    end

    "#{next_user.username}"
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
  def players_generator2(conn, _params) do
    raw_players =
      File.read!("data/players.json")
      |> Poison.decode!

    ultimate_positions =
      CSVLixir.read("data/ultimate.csv") |> Enum.to_list

    lists = raw_players["lists"]
    players_list = Enum.map(lists, fn x ->
      player_name = x["player"]["givenName"] <> " " <> x["player"]["surname"]

      position = Enum.filter(ultimate_positions, fn x -> Enum.at(x, 0) <> " " <> Enum.at(x, 1) == player_name end)
      |> List.first

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

  def players_generator(conn, _params) do
    fantasy_players =
      File.read!("data/fantasy.json")
      |> Poison.decode!

    squads =
      File.read!("data/squads.json")
      |> Poison.decode!

    position_descriptions = %{
      1 => "Defender",
      2 => "Mid",
      3 => "Ruck",
      4 => "Forward"
    }

    players_list = Enum.map(fantasy_players, fn x ->

      [team] = Enum.filter(squads, fn(squad) -> squad["id"] == x["squad_id"] end)

      positions = Enum.map(x["positions"], fn(position) -> position_descriptions[position] end)

      %{
        "givenName" => x["first_name"],
        "surname" => x["last_name"],
        "photoURL" => "https://fantasy.afl.com.au/assets/media/players/afl/#{x["id"]}_100.png",
        # "jumper" => x["player"]["jumper"],
        "playerId" => x["id"],
        "teamId" => x["squad_id"],
        "teamAbbr" => team["short_name"],
        "teamName" => team["name"],
        # "teamNickname" => x["team"]["teamNickname"],
        # # "new_player_id" => player_name,
        "positions" => positions
      }

    end )

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
