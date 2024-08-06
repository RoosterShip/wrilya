defmodule Utils.MixProject do
  use Mix.Project

  def project do
    [
      app: :utils,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # For Ecto Tools
      {:ecto, "~> 3.11"},

      # Crypto Libs
      {:ex_keccak, "~> 0.7"},
      {:ex_secp256k1, "~> 0.7"},
      {:ex_base58, "~> 0.6"},
      {:ed25519, "~> 1.4"}
    ]
  end

  defp aliases do
    [
      setup: []
    ]
  end
end
