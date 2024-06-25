defmodule Wrilya.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Wrilya.Repo,
      {Oban, Application.fetch_env!(:wrilya, Oban)},
      {DNSCluster, query: Application.get_env(:wrilya, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wrilya.PubSub},
      {Finch, name: Wrilya.Finch},
      Wrilya.Discord.Supervisor,
      Wrilya.Chain.Supervisor,
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Wrilya.Supervisor)
  end
end
