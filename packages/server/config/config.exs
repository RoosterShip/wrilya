# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :faucet,
  ecto_repos: [Faucet.Repo]

config :faucet, Oban,
  engine: Oban.Pro.Engines.Smart,
  repo: Faucet.Repo,
  name: Faucet.Oban,
  plugins: [
    Oban.Pro.Plugins.DynamicLifeline,
    Oban.Pro.Plugins.DynamicPrioritizer,
    {
      Oban.Pro.Plugins.DynamicQueues,
      queues: [
        drips: [global_limit: 1]
      ]
    }
  ]

# ------------------------------------------------------------------------------
# Account Configuration
# ------------------------------------------------------------------------------

# Configure Mix tasks and generators
config :account,
  ecto_repos: [Account.Repo]

config :account, Account.Guardian,
  issuer: "Account.Guardian",
  ttl: {1, :hour},
  secret_key: System.get_env("GUARDIAN_SECRET")

# ------------------------------------------------------------------------------
# MUD Configuration
# ------------------------------------------------------------------------------

config :mud,
  ecto_repos: [MUD.Repo]

# ------------------------------------------------------------------------------
# Wrilya Configurations
# ------------------------------------------------------------------------------

# Configure Mix tasks and generators
config :wrilya,
  ecto_repos: [Wrilya.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :wrilya, Wrilya.Mailer, adapter: Swoosh.Adapters.Local

config :wrilya_web,
  ecto_repos: [Wrilya.Repo],
  generators: [context_app: :wrilya]

config :wrilya, Oban,
  engine: Oban.Pro.Engines.Smart,
  repo: Wrilya.Repo,
  name: Wrilya.Oban,
  plugins: [
    Oban.Pro.Plugins.DynamicLifeline,
    Oban.Pro.Plugins.DynamicPrioritizer
    # Oban.Pro.Plugins.DynamicLifeline,
    # {
    #  Oban.Pro.Plugins.DynamicCron,
    #  crontab: [
    #    # Cron job to watch the faucet
    #    {"0 * * * *", Wrilya.Chain.Faucet.Monitor}
    #  ]
    # },
    # {
    #  Oban.Pro.Plugins.DynamicQueues,
    #  queues: [
    #    default: 20,
    #    mailers: [global_limit: 20],
    #    events: [local_limit: 30, rate_limit: [allowed: 100, period: 60]]
    #  ]
    # }
  ]

# Configures the endpoint
config :wrilya_web, WrilyaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: WrilyaWeb.ErrorHTML, json: WrilyaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Wrilya.PubSub,
  live_view: [signing_salt: System.get_env("WRILYA_WEB_SIGNING_SALT")]

# ------------------------------------------------------------------------------
# Auth Setup Configurations
# ------------------------------------------------------------------------------

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email"]},
    discord: {Ueberauth.Strategy.Discord, [default_scope: "identify email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("DISCORD_CLIENT_ID"),
  client_secret: System.get_env("DISCORD_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  ffmpeg: nil

config :guardian, Guardian.DB, adapter: GuardianRedis.Adapter

# ------------------------------------------------------------------------------
# ESBuild Configurations
# ------------------------------------------------------------------------------

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  wrilya_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/wrilya_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  wrilya_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/wrilya_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nostrum,
  num_shards: :auto

config :tesla, :adapter, {Tesla.Adapter.Finch, name: Wrilya.Finch}

config :ethers,
  # Defaults to: Ethereumex.HttpClient
  rpc_client: Ethereumex.HttpClient,
  # Defaults to: ExKeccak
  keccak_module: ExKeccak,
  # Defaults to: Jason
  json_module: Jason,
  # Defaults to: ExSecp256k1
  secp256k1_module: ExSecp256k1,
  # Defaults to: nil, see Ethers.Signer for more info
  default_signer: nil,
  # Defaults to: []
  default_signer_opts: []

# If using Ethereumex, you can specify a default JSON-RPC server url here for all requests.
config :ethereumex, url: "http://localhost:8545"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
