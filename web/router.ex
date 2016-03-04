defmodule DraftServer.Router do
  use DraftServer.Web, :router
  require Sentinel

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api/v1", DraftServer do # Api.V1
    pipe_through [:api]

    get "/the_users", UserController, :index

    get "/drafts/players", DraftController, :players

    resources "/drafts", DraftController, except: [:new, :edit]
  end

  scope "/api/v1" do
    pipe_through [:api]
    Sentinel.mount
  end

  scope "/", DraftServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController # TEMP
  end

  # Other scopes may use custom stacks.
  # scope "/api", DraftServer do
  #   pipe_through :api
  # end
end
