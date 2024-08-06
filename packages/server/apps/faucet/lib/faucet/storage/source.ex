defmodule Faucet.Storage.Source do
  @moduledoc """
  CRUD and expanded APIs for managing a source state
  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Utils.Types
  use Utils.Storage.StdCRUD, context: Faucet.Storage.Source.Record, repo: Faucet.Repo

  # ----------------------------------------------------------------------------
  # Module APIs
  # ----------------------------------------------------------------------------

  @doc """
  Check if the faucet is active
  """
  @spec active?(id :: uuid()) :: boolean()
  def active?(id) do
    from(s in Record, where: s.id == ^id and s.active == true)
    |> Repo.exists?()
  end

  @doc """
  Set the state of a source
  """
  @spec set_active(id :: uuid(), state :: boolean) :: :ok | :error
  def set_active(id, state) do
    now = NaiveDateTime.utc_now(:second)

    from(s in Faucet.Storage.Source.Record,
      where: s.id == ^id,
      update: [set: [active: ^state, updated_at: ^now]]
    )
    |> Repo.update_all([])
    |> case do
      {1, _} ->
        :ok

      _ ->
        :error
    end
  end

  @doc """
  Load a source record and all it's keys from the database
  """
  @spec load!(id :: uuid()) :: %Faucet.Storage.Source.Record{}
  def load!(id) do
    k_query = from(k in Faucet.Storage.Key.Record, where: k.active)

    from(p in Faucet.Storage.Source.Record,
      where: p.id == ^id,
      preload: [keys: ^k_query]
    )
    |> Repo.one!()
  end
end
