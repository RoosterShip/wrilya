defmodule Wrilya.MixProject do
  use Mix.Project

  def project do
    [
      app: :wrilya,
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
      mod: {Wrilya.Application, []},
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
      # Project Deps
      {:utils, in_umbrella: true},

      # Phoenix includes
      {:dns_cluster, "~> 0.1.3"},
      {:phoenix_pubsub, "~> 2.1"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.4"},
      {:swoosh, "~> 1.16"},
      # RabbitMQ integration
      {:amqp, "~> 3.3"},
      {:rabbit_common, "~> 3.13", override: true},

      # Discord integration
      {:nostrum, "~> 0.9"},

      # Tesla integration
      {:tesla, "~> 1.9"},
      {:finch, "~> 0.18"},

      # Graph QL
      {:gql, "~> 0.6.2"},

      # Oban
      {:oban_pro, "~> 1.4.9", repo: "oban"},

      # Ethereum
      {:rustler, ">= 0.0.0"},
      {:ex_secp256k1, "~> 0.7.3"},
      {:ethers, "~> 0.5.0"},

    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
