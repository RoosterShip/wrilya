defmodule Faucet do
  @moduledoc """
  Adds some tokens to a specific address.  This is a typical faucet that maintains
  time and value gates.
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Utils.Types

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Check if a source is still active
  """
  @spec active?(source :: uuid()) :: boolean()
  def active?(source), do: Faucet.Storage.source_active?(source)

  @doc """
  Adds the default drip amount to the given address if they pass all checks
  """
  @spec drip(to :: String.t(), source :: uuid()) :: :ok | :error
  def drip(to, source) do
    if Faucet.Storage.drip_eligible?(to, source) do
      Oban.insert(Faucet.Oban, Faucet.Worker.Drip.new(%{to: to, source: source}))
      :ok
    else
      :error
    end
  end

  # @doc """
  # Adds the default drip amount to the given address if they pass all checks using
  # a `Task`.
  #
  # NOTE:
  #
  # The return of the task does NOT mean the drip has completed, just that all primary
  # checks have been completed and the drip request is not QUEUED for execution
  # """
  # @spec drip_async(to :: String.t(), from :: uuid()) :: Task.t()
  # def drip_async(to, from), do: Task.async(fn -> drip(to, from) end)

  @doc """
  Add an address or a list of addresses the banned accounts
  """
  @spec ban(source_id :: uuid(), addressOrAddresses :: String.t() | [String.t()]) :: :ok
  def ban(source_id, addressOrAddresses) do
    Faucet.Storage.ban_add(source_id, addressOrAddresses)
    :ok
  end

  @doc """
  Async task version of `ban` in cases where waiting for the DB operations is not
  desired.
  """
  @spec ban_async(
          source_id :: uuid(),
          addressOrAddresses :: String.t() | [String.t()]
        ) ::
          Task.t()
  def ban_async(source_id, addressOrAddresses),
    do: Task.async(fn -> ban(source_id, addressOrAddresses) end)

  @doc """
  Removes an address or a list of addresses the banned accounts
  """
  @spec unban(
          source_id :: uuid(),
          addressOrAddresses :: String.t() | [String.t()]
        ) ::
          :ok
  def unban(source_id, addressOrAddresses) do
    Faucet.Storage.Banned.remove(source_id, addressOrAddresses)
    :ok
  end

  @doc """
  Async task version of `unban` in cases where waiting for the DB operations is
  not desired.
  """
  @spec unban_async(
          source_id :: uuid(),
          addressOrAddresses :: String.t() | [String.t()]
        ) ::
          Task.t()
  def unban_async(source_id, addressOrAddresses),
    do: Task.async(fn -> unban(source_id, addressOrAddresses) end)
end
