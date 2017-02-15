defmodule DraftServer.Mixfile do
  use Mix.Project

  def project do
    [app: :draft_server,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {DraftServer, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :guardian, :sentinel,
                    :rollbax, :logger_file_backend, :secure_random,
                    :cors_plug, :csvlixir, :phoenix_pubsub
                   ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:guardian, "~> 0.14.2"},
      # {:sentinel, "~> 0.0.4", github: "TigerWolf/sentinel", ref: "1b05ad719d229cf6f6423823ffa5fd73366eaf2b"},
      {:sentinel, "~> 1.0.2"},
      {:distillery, "~> 1.0"},
      {:rollbax, "~> 0.5"},
      {:logger_file_backend, "0.0.4"},
      {:secure_random, "~> 0.2"}, # For Sentinel
      {:csvlixir, "~> 2.0"},
      {:cors_plug, "~> 1.1"},
   ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
