import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do

  faucet_postgres_username =
    System.get_env("FAUCET_POSTGRES_USER") ||
      raise """
      environment variable FAUCET_POSTGRES_USER is missing.
      Please review the Pulumi config files to find it.
      """

  faucet_postgres_password =
    System.get_env("FAUCET_POSTGRES_PASSWORD") ||
      raise """
      environment variable FAUCET_POSTGRES_PASSWORD is missing.
      Please review the Pulumi config files to find it.
      """

  faucet_postgres_hostname =
    System.get_env("FAUCET_POSTGRES_HOSTNAME") ||
      raise """
      environment variable FAUCET_POSTGRES_HOSTNAME is missing.
      Please review the Pulumi config files to find it.
      """

  faucet_postgres_database =
    System.get_env("FAUCET_POSTGRES_DATABASE") ||
      raise """
      environment variable FAUCET_POSTGRES_DATABASE is missing.
      Please review the Pulumi config files to find it.
      """

  wrilya_postgres_username =
    System.get_env("WRILYA_POSTGRES_USER") ||
      raise """
      environment variable WRILYA_POSTGRES_USER is missing.
      Please review the Pulumi config files to find it.
      """

  wrilya_postgres_password =
    System.get_env("WRILYA_POSTGRES_PASSWORD") ||
      raise """
      environment variable WRILYA_POSTGRES_PASSWORD is missing.
      Please review the Pulumi config files to find it.
      """

  wrilya_postgres_hostname =
    System.get_env("WRILYA_POSTGRES_HOST") ||
      raise """
      environment variable WRILYA_POSTGRES_HOST is missing.
      Please review the Pulumi config files to find it.
      """

  wrilya_postgres_database =
    System.get_env("WRILYA_POSTGRES_DATABASE") ||
      raise """
      environment variable WRILYA_POSTGRES_DATABASE is missing.
      Please review the Pulumi config files to find it.
      """

  account_postgres_username =
    System.get_env("ACCOUNT_POSTGRES_USER") ||
      raise """
      environment variable ACCOUNT_POSTGRES_USER is missing.
      Please review the Pulumi config files to find it.
      """

  account_postgres_password =
    System.get_env("ACCOUNT_POSTGRES_PASSWORD") ||
      raise """
      environment variable ACCOUNT_POSTGRES_PASSWORD is missing.
      Please review the Pulumi config files to find it.
      """

  account_postgres_hostname =
    System.get_env("ACCOUNT_POSTGRES_HOST") ||
      raise """
      environment variable ACCOUNT_POSTGRES_HOST is missing.
      Please review the Pulumi config files to find it.
      """

  account_postgres_database =
    System.get_env("ACCOUNT_POSTGRES_DATABASE") ||
      raise """
      environment variable ACCOUNT_POSTGRES_DATABASE is missing.
      Please review the Pulumi config files to find it.
      """

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  wrilya_port =
    System.get_env("WRILYA_PORT") ||
      raise """
      environment variable WRILYA_PORT is missing.
      """

  # nodule_port =
  #  System.get_env("NODULE_PORT") ||
  #    raise """
  #    environment variable NODULE_PORT is missing.
  #    """

  discord_token =
    System.get_env("DISCORD_TOKEN") ||
      raise """
      environment variable "DISCORD_TOKEN" is missing.
      Please fetch this info from discord and set it as an environment variable
      """

  account_redis_host =
    System.get_env("ACCOUNT_REDIS_HOST") ||
      raise """
      environment variable "ACCOUNT_REDIS_HOST" is missing.
      """

  discord_client_id =
    System.get_env("DISCORD_CLIENT_ID") ||
      raise """
      environment variable "DISCORD_CLIENT_ID" is missing.
      """

  discord_client_secret =
    System.get_env("DISCORD_CLIENT_SECRET") ||
      raise """
      environment variable "DISCORD_CLIENT_SECRET" is missing.
      """

  google_client_id =
    System.get_env("GOOGLE_CLIENT_ID") ||
      raise """
      environment variable "GOOGLE_CLIENT_ID" is missing.
      """

  google_client_secret =
    System.get_env("GOOGLE_CLIENT_SECRET") ||
      raise """
      environment variable "GOOGLE_CLIENT_SECRET" is missing.
      """

  account_vault_key =
    System.get_env("ACCOUNT_VAULT_KEY") ||
      raise """
      environment variable "ACCOUNT_VAULT_KEY" is missing.
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  # ----------------------------------------------------------------------------
  # Wrilya Runtime Configuration
  # ----------------------------------------------------------------------------

  config :wrilya, Wrilya.Repo,
    # ssl: true,
    username: wrilya_postgres_username,
    password: wrilya_postgres_password,
    hostname: wrilya_postgres_hostname,
    database: wrilya_postgres_database,
    pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  config :wrilya_web, WrilyaWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(wrilya_port)
    ],
    server: true,
    secret_key_base: secret_key_base

  config :wrilya, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  # ----------------------------------------------------------------------------
  # Nostrum Runtime Configuration
  # ----------------------------------------------------------------------------
  config :nostrum,
    token: discord_token

  # ----------------------------------------------------------------------------
  # Guardian and Account Runtime Configuration
  # ----------------------------------------------------------------------------
  config :guardian_redis, :redis,
    host: account_redis_host,
    port: System.get_env("ACCOUNT_REDIS_PORT", "6379") |> String.to_integer(),
    pool_size: String.to_integer(System.get_env("ACCOUNT_REDIS_POOL") || "10")

  config :account, Account.Repo,
    # ssl: true,
    username: account_postgres_username,
    password: account_postgres_password,
    hostname: account_postgres_hostname,
    database: account_postgres_database,
    pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  config :account, Account.Vault,
    ciphers: [
      default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: Base.decode64!(account_vault_key)}
    ]

  # ------------------------------------------------------------------------------
  #  Runtime Configuration
  # ------------------------------------------------------------------------------
  config :faucet, Faucet.Repo,
    # ssl: true,
    username: faucet_postgres_username,
    password: faucet_postgres_password,
    hostname: faucet_postgres_hostname,
    database: faucet_postgres_database,
    pool_size: String.to_integer(System.get_env("POSTGRES_POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # ------------------------------------------------------------------------------
  # Ueberauth Runtime Configuration
  # ------------------------------------------------------------------------------
  config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
    client_id: discord_client_id,
    client_secret: discord_client_secret

  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: google_client_id,
    client_secret: google_client_secret
end
