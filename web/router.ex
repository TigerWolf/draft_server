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

    get "/drafts/players_generator", DraftController, :players_generator
    get "/drafts/players", DraftController, :players
    # get "/drafts/players", DraftController, :players_generator
    get "/drafts/message", DraftController, :message

    get "/drafts/me", DraftController, :me

    resources "/drafts", DraftController, except: [:new, :edit]
  end

  scope "/api/v1" do
    pipe_through [:api]
    Sentinel.mount_api
  end

  pipeline :sentinel_ueberauth_json do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :sentinel_ueberauth_html do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :sentinel_ueberauth_html
    Sentinel.mount_ueberauth
  end

  scope "/api/v1" do
    pipe_through :sentinel_ueberauth_json
    Sentinel.mount_ueberauth
  end

  scope "/" do
    pipe_through :browser
    Sentinel.mount_html
  end

  scope "/", DraftServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/dashboard", PageController, :dashboard
    # resources "/users", UserController # TEMP

  end

  # Other scopes may use custom stacks.
  # scope "/api", DraftServer do
  #   pipe_through :api
  # end
end
