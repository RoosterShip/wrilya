defmodule Faucet.Storage do
  @moduledoc """
  Interact with storage-state of the faucet.  This module is meant to act more
  as a "meta" operation and increase encapsulation of the individual calls.
  """

  # ----------------------------------------------------------------------------
  # Module Imports
  # ----------------------------------------------------------------------------
  import Ecto.Query, warn: false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Utils.Types

  @doc """
  Create a new source record in the storage
  """
  @spec source_create(data :: map(), opts :: keyword()) ::
          {:ok, %Faucet.Storage.Source.Record{}} | {:error, term()}
  def source_create(data, opts \\ []) do
    data
    |> Map.put(:id, Keyword.get(opts, :id, Ecto.UUID.generate()))
    |> Faucet.Storage.Source.create()
  end

  @doc """
  Check if a source is active
  """
  @spec source_active?(id :: uuid()) :: boolean()
  def source_active?(id), do: Faucet.Storage.Source.active?(id)

  @doc """
  Create a new key based on the
  """
  @spec key_create(data :: map(), opts :: keyword()) ::
          {:ok, %Faucet.Storage.Key.Record{}} | {:error, term()}
  def key_create(data, opts \\ []) do
    # Format or generate the key if needed
    case Map.get(data, :key, nil) do
      nil ->
        Map.put(data, :key, Utils.Key.build(Map.get(data, :type, :secp256k1)).private)

      key when byte_size(key) == 32 ->
        data

      key ->
        Map.put(data, :key, Utils.hex_to_bin(key))
    end
    # Generate an ID
    |> Map.put(:id, Keyword.get(opts, :id, Ecto.UUID.generate()))
    # Create the table record
    |> Faucet.Storage.Key.create()
  end

  @doc """
  An optimized query to see if a user can receiver a drip from a faucet

  NOTE: I believe that there is a better way to do this in ecto but for
        now it should be good enough and we can always increase performance
        at a later date IF needed.
  """
  @spec drip_eligible?(to :: String.t(), source :: uuid()) :: boolean()
  def drip_eligible?(to, source) do
    q =
      from(s in Faucet.Storage.Source.Record,
        where: s.id == ^source and s.active == true and s.type == :faucet,
        select: "s"
      )

    from(b in Faucet.Storage.Banned.Record,
      where: b.address == ^to,
      select: "b",
      union_all: ^q
    )
    |> Faucet.Repo.all()
    |> case do
      ["s"] -> true
      _ -> false
    end
  end

  @doc """
  Database check to see if the source meets the drips requirements currently set
  """
  @spec source_eligible?(source :: %Faucet.Storage.Source.Record{}) :: boolean()
  def source_eligible?(source), do: Faucet.Storage.Drip.eligible?(source)

  @doc """
  Database check to see if the receiver meets the drips requirements currently set
  """
  @spec receiver_eligible?(
          source :: %Faucet.Storage.Source.Record{},
          address :: String.t()
        ) ::
          boolean()
  def receiver_eligible?(source, address), do: Faucet.Storage.Drip.eligible?(source, address)

  @doc """
  Add a banned user to a source
  """
  @spec ban_add(source_id :: uuid(), addressOrAddresses :: String.t() | [String.t()]) :: :ok
  def ban_add(source_id, addressOrAddresses),
    do: Faucet.Storage.Banned.add(source_id, addressOrAddresses)

  @doc """
  Remove a banned user from a source
  """
  @spec ban_remove(source_id :: uuid(), addressOrAddresses :: String.t() | [String.t()]) :: :ok
  def ban_remove(source_id, addressOrAddresses),
    do: Faucet.Storage.Banned.remove(source_id, addressOrAddresses)
end
