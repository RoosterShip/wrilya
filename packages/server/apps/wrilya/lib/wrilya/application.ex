defmodule Wrilya.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Wrilya.Repo,
      {DNSCluster, query: Application.get_env(:wrilya, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wrilya.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Wrilya.Finch}
      # Start a worker by calling: Wrilya.Worker.start_link(arg)
      # {Wrilya.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Wrilya.Supervisor)
  end
end
