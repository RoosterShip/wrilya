defmodule Faucet.Worker.Drip do
  @moduledoc """
  An Oban Pro Work that will process faucet drip requests in chunks.

  The goal of this system is to reduce the number of inflight transactions
  by the faucet server down to only one but that one transaction can batch
  many drip requests into one transaction that executes on chain.
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Oban.Pro.Workers.Chunk,
    queue: :drips,
    by: [:worker, args: :source],
    size: Application.compile_env(:faucet, :drip_chunk_size, 100),
    timeout: Application.compile_env(:faucet, :drip_chunk_timeout, 1000)

  # ----------------------------------------------------------------------------
  # Module Public API
  # ----------------------------------------------------------------------------

  @doc """
  Callback made by Oban when a chunk of drips are ready to be processed.
  """
  @impl true
  @spec process(nonempty_maybe_improper_list()) :: :ok
  def process([_ | _] = jobs) do
    Logger.debug("[Faucet.Worker.Drip] Begin")

    Enum.at(jobs, 0).args["source"]
    |> Faucet.Storage.Source.load!()
    |> drip(jobs)

    # Drip Complete
    Logger.debug("[Faucet.Worker.Drip] Complete")
    :ok
  rescue
    e ->
      Logger.error("[Faucet.Worker.Drip] Failed: #{inspect(e)}")
      :ok
  end

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp drip(source, jobs) do
    with true <- Faucet.Storage.source_eligible?(source),
         true <- source.active,
         addresses <- drip_addresses(source, jobs),
         true <- [] != addresses,
         amount <- length(addresses) * source.drip_amount,
         key <- drip_key(source, amount),
         true <- :no_key != key do
      txn =
        Faucet.Contract.drip(addresses)
        |> Ethers.send(
          from: Map.get(key, :address),
          to: Application.get_env(:faucet, :contract),
          signer: Ethers.Signer.Local,
          signer_opts: [private_key: Utils.bin_to_hex(key.key)],
          value: amount
        )

      # Record to the DB that we at least tried to faucet these guys out
      Faucet.Storage.Drip.record(source, addresses)
      wait_txn(txn)
    else
      false ->
        Logger.info("[Faucet.Worker.Drip] System state marked drip as ineligible")

      e ->
        Logger.error("[Faucet.Worker.Drip] Drip Exception: #{inspect(e)}")
    end

    :ok
  end

  defp drip_addresses(source, jobs) do
    Enum.reduce(jobs, [], fn job, acc -> [job.args["to"] | acc] end)
    |> Enum.uniq()
    |> Enum.map(fn addr ->
      Task.async(fn ->
        if Faucet.Storage.receiver_eligible?(source, addr) do
          case Ethers.get_balance(addr) do
            {:ok, balance} when balance <= source.receiver_max_balance ->
              addr

            _ ->
              "0"
          end
        else
          "0"
        end
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.filter(fn addr -> "0" != addr end)
  end

  defp drip_key(source, amount) do
    Enum.shuffle(source.keys)
    |> Enum.map(fn key ->
      Task.async(fn ->
        if key.active do
          address =
            Utils.Key.build(key.type, key.key)
            |> Utils.Key.address_string()

          Ethers.get_balance(address)
          |> case do
            {:ok, balance} when balance >= amount ->
              Map.put(key, :address, address)

            _ ->
              # If we have a reservoir let's try and pull some value from it
              if source.reservoir_id do
                Oban.insert(
                  Faucet.Oban,
                  Faucet.Worker.Drip.new(%{
                    to: address,
                    source: source.reservoir_id
                  })
                )
              end

              :no_key
          end
        else
          :no_key
        end
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.find(:no_key, fn key -> key != :no_key end)
  end

  defp wait_txn(value, sleep \\ 1000, ticks \\ 10)

  defp wait_txn({:error, e}, _sleep, _ticks),
    do: Logger.error("[Faucet.Worker.Drip] Transaction Failed: #{inspect(e)}")

  defp wait_txn({:ok, txn}, sleep, ticks), do: wait_txn(txn, sleep, ticks)
  defp wait_txn(_txn, _sleep, 0), do: :ok

  defp wait_txn(txn, sleep, ticks) do
    case Ethers.get_transaction(txn) do
      {:error, _} ->
        Process.sleep(sleep)
        wait_txn(txn, sleep, ticks - 1)

      {:ok, _} ->
        :ok
    end
  end
end
