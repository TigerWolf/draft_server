defmodule DraftServer.SessionController do
  use DraftServer.Web, :controller

  alias DraftServer.User

  # plug :scrub_params, "user" when action in [:create]

  def create(conn, params = %{}) do
    user = Repo.get(User, 2)
    # user = %User{id: 1}
    # permissions = {} #verified_user.permissions

    permissions = Guardian.Claims.app_claims
         |> Map.put("user", 2)
         |> Guardian.Claims.ttl({3, :days})

    case Guardian.encode_and_sign(user, :token, permissions) do
      { :ok, token, encoded_claims } -> json conn, %{token: token}
      # { :error, :token_storage_failure } -> Util.send_error(conn, %{error: "Failed to store session, please try to login again using your new password"})
      # { :error, reason } -> Util.send_error(conn, %{error: reason})
      { :error, error} -> json conn, %{error: error}
    end

    # conn
    # |> fetch_session
    # # |> put_flash(:info, "Logged in.")
    # |> Guardian.Plug.sign_in(verified_user, :token) # verify your logged in resource
    #
    # |> redirect(to: user_path(conn, :index))
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
