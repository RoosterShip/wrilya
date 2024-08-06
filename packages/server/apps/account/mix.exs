defmodule Account.MixProject do
  use Mix.Project

  def project do
    [
      app: :account,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Account.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:dns_cluster, "~> 0.1.3"},
      {:phoenix_pubsub, "~> 2.1"},
      {:jason, "~> 1.4"},

      # Ecto Libs
      {:ecto_sql, "~> 3.11"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_psql_extras, "~> 0.8"},
      {:ecto_commons, "~> 0.3"},
      {:cloak_ecto, "~> 1.3"},
      {:flop, "~> 0.25.0"},

      # Guardian
      {:guardian, "~> 2.3"},
      {:guardian_db, "~> 3.0"},
      {:guardian_redis, "~> 0.2.0"},
      {:guardian_phoenix, "~> 2.0"},

      # Tesla integration
      {:tesla, "~> 1.9"},
      {:finch, "~> 0.18"},

      # Project Deps
      {:utils, in_umbrella: true},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run #{__DIR__}/priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
