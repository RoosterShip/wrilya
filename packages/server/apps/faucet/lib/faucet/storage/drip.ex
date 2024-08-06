defmodule Faucet.Storage.Drip do
  @moduledoc """

  """
  require Logger

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdCRUD, context: Faucet.Storage.Drip.Record, repo: Faucet.Repo

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec eligible?(source :: %Faucet.Storage.Source.Record{}) :: boolean()
  def eligible?(source) do
    if source.active and source.drips_per_window > 0 do
      lastTime = NaiveDateTime.add(NaiveDateTime.utc_now(:second), -source.window_size, :second)

      count =
        from(d in Record,
          where: d.source_id == ^source.id and d.inserted_at > ^lastTime
        )
        |> Faucet.Repo.aggregate(:count)

      count < source.drips_per_window
    else
      source.active
    end
  end

  @doc """
  """
  @spec eligible?(
          source :: %Faucet.Storage.Source.Record{},
          address :: String.t()
        ) :: boolean()
  def eligible?(source, address) do
    if source.active and source.receiver_drips_per_window > 0 do
      lastTime = NaiveDateTime.add(NaiveDateTime.utc_now(:second), -source.window_size, :second)
      {:ok, addr} = Utils.Storage.Ecto.Hex.Binary.cast(address)

      count =
        from(d in Record,
          where: d.source_id == ^source.id and d.address == ^addr and d.inserted_at > ^lastTime
        )
        |> Faucet.Repo.aggregate(:count)

      count < source.receiver_drips_per_window
    else
      source.active
    end
  end

  @doc """
  """
  @spec record(
          source :: %Faucet.Storage.Source.Record{},
          addresses :: [String.t()]
        ) :: :ok
  def record(source, addresses) do
    now = NaiveDateTime.utc_now(:second)

    recs =
      Enum.reduce(addresses, [], fn address, acc ->
        {:ok, addr} = Utils.Storage.Ecto.Hex.Binary.cast(address)

        [
          %{
            id: Ecto.UUID.generate(),
            source_id: source.id,
            address: addr,
            amount: source.drip_amount,
            inserted_at: now,
            updated_at: now
          }
          | acc
        ]
      end)

    _ = Repo.insert_all(Record, recs)
    :ok
  end
end
