defmodule Account.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Account.Repo,
      Account.Vault,
      {DNSCluster, query: Application.get_env(:account, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Account.PubSub},
      {Finch, name: Account.Finch},
      {Guardian.DB.Sweeper, [interval: 60 * 60 * 1000]},
      GuardianRedis.Redix,
      {Task, fn -> Account.seed!() end}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Account.Supervisor)
  end
end
