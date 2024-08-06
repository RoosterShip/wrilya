defmodule Faucet.Storage.Key do
  @moduledoc """

  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdCRUD, context: Faucet.Storage.Key.Record, repo: Faucet.Repo
end
