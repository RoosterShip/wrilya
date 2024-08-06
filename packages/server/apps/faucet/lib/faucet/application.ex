defmodule Faucet.Application do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Application

  # ----------------------------------------------------------------------------
  # Module Public API
  # ----------------------------------------------------------------------------

  @impl true
  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    children = [
      Faucet.Repo,
      Faucet.Vault,
      {Oban, Application.fetch_env!(:faucet, Oban)},
      {DNSCluster, query: Application.get_env(:faucet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Faucet.PubSub},
      {Finch, name: Faucet.Finch},
      # Do some loading tests after everything else is running
      {Task, &load_sources/0}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Faucet.Supervisor)
  end

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------

  defp load_sources() do
    Application.get_env(:faucet, :sources, %{})
    # Let's make sure we record the spouts first
    |> Enum.sort_by(fn {_, rec} -> if(rec.type == :reservoir, do: 0, else: 1) end)
    |> Enum.each(fn {id, rec} ->
      load_source(id, rec)
    end)
  end

  defp load_source(id, %{keys: keys} = record) do
    record = Map.delete(record, :keys)

    case Faucet.Storage.source_create(record, id: id) do
      {:ok, _} ->
        Enum.each(keys, fn key -> load_key(id, key.type, key.key) end)

      _ ->
        :ok
    end
  end

  defp load_key(source_id, type, key) do
    %{
      source_id: source_id,
      type: type,
      key: key,
      active: true
    }
    |> Faucet.Storage.key_create()
  end
end
