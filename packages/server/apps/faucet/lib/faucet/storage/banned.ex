defmodule Faucet.Storage.Banned do
  @moduledoc """
  Some special case query and update operations for Banned User Management
  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Utils.Types
  use Utils.Storage.StdCRUD, context: Faucet.Storage.Banned.Record, repo: Faucet.Repo

  # ----------------------------------------------------------------------------
  # Module APIs
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec member?(source_id :: uuid(), address :: String.t()) :: boolean
  def member?(source_id, address) do
    from(b in Record, where: b.address == ^address and b.source_id == ^source_id)
    |> Repo.exists?()
  end

  @doc """
  Add address to the banned list for a source
  """
  @spec add(source_id :: uuid(), addresses :: String.t() | [String.t()]) :: :ok
  def add(source_id, addresses) when is_list(addresses) do
    now = NaiveDateTime.utc_now(:second)

    recs =
      Enum.reduce(addresses, [], fn address, acc ->
        [
          %{
            id: Ecto.UUID.bingenerate(),
            source_id: source_id,
            address: address,
            inserted_at: now,
            updated_at: now
          }
          | acc
        ]
      end)

    _ = Repo.insert_all(Record, recs)
    :ok
  end

  def add(source_id, address) do
    _ = create(%{source_id: source_id, address: address})
    :ok
  end

  @doc """
  Remove address from the banned list for a source
  """
  @spec remove(source_id :: uuid(), addresses :: String.t() | [String.t()]) :: :ok
  def remove(source_id, addresses) when is_list(addresses) do
    from(b in Record, where: b.address in ^addresses and b.source_id == ^source_id)
    |> Repo.delete_all()
  end

  def remove(source_id, address) do
    from(b in Record, where: b.address == ^address and b.source_id == ^source_id)
    |> Repo.delete_all()
  end
end
