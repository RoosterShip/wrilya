defmodule Faucet.Contract do
  @moduledoc """
  Wrapper for Ethers to call the smart contract used to batch drips out.
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ethers.Contract,
    abi_file: Application.app_dir(:faucet, "/priv/abi/Faucet.abi.json")
end
