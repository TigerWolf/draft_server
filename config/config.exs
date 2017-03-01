# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :draft_server, DraftServer.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Dpo+YpjXjXkL/an3R9ChOXOIkxaBPBz127YvTV8KnY1qPC34yklnqf7GZY+s9oDu",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: DraftServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :draft_server, ecto_repos: [DraftServer.Repo]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyApp",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "ef2a2b1175347ee39cc3201355c719f8e7f2fe4d83fdf652a7c56899a2ea0a751e43c907e6bda7933650db5d7d150eeb91d3b530da7757b906eb08a78ff94fd4",
  serializer: Sentinel.GuardianSerializer
  # hooks: GuardianDb

# config :guardian_db, GuardianDb,
#   repo: MyApp.Repo

# config :sentinel,
#   app_name: "Test App",
#   user_model: DraftServer.User,
#   email_sender: "test@example.com",
#   crypto_provider: Comeonin.Bcrypt,
#   auth_handler: Sentinel.AuthHandler, #optional
#   repo: DraftServer.Repo,
#   confirmable: :false, # possible options {:false, :required, :optional},optional config
#   endpoint: DraftServer.Endpoint,
#   router: DraftServer.Router

config :sentinel,
  app_name: "Test App",
  user_model: DraftServer.User, # should be your generated model
  send_address: "test@example.com",
  crypto_provider: Comeonin.Bcrypt,
  repo: DraftServer.Repo,
  ecto_repos: [DraftServer.Repo],
  auth_handler: Sentinel.AuthHandler,
  layout_view: DraftServer.LayoutView, # your layout
  user_view: DraftServer.UserView,
  error_view: DraftServer.ErrorView,
  router: DraftServer.Router , # your router
  endpoint: DraftServer.Endpoint, # your endpoint
  invitable: true,
  invitation_registration_url: "http://localhost:4000", # for api usage only
  confirmable: :optional,
  confirmable_redirect_url: "http://localhost:4000", # for api usage only
  password_reset_url: "http://localhost:4000", # for api usage only
  send_emails: true

config :ueberauth, Ueberauth,
  providers: [
    identity: {
      Ueberauth.Strategy.Identity,
      [
        param_nesting: "user",
        callback_methods: ["POST"]
      ]
    },
  ]

  config :sentinel, Sentinel.Mailer,
    adapter: Bamboo.TestAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
