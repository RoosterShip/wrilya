defmodule Utils.Types do
  @moduledoc """
  Documentation for `Utils`.
  """

  require Logger

  # ----------------------------------------------------------------------------
  # Module Using Definition
  # ----------------------------------------------------------------------------
  @spec __using__(any()) :: {:__block__, [], [{:@, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      @type uuid :: Ecto.UUID.t()

      @key_types [secp256k1: 0, ed25519: 1]
      @key_values [:secp256k1, :ed25519]
      @type key_types :: :secp256k1 | :ed25519

      @chain_types [
        ethereum: 0,
        polygon: 1,
        polygon_zkevm: 2,
        avalanche: 3,
        linea: 4,
        zksync: 5,
        sol: 6,
        near: 7,
        xrpl: 8,
        aleo: 9
      ]

      @type chain_types ::
              :ethereum
              | :polygon
              | :polygon_zkevm
              | :avalanche
              | :arbitrum_one
              | :arbitrum_nova
              | :linea
              | :zksync
              | :sol
              | :near
              | :xrpl
              | :aleo

      @network_types [
        localhost: 1337,
        ethereum_mainnet: 1,
        ethereum_goerli: 5,
        ethereum_sepolia: 11_155_111,
        polygon_mainnet: 137,
        polygon_testnet: 80_001,
        polygon_zkevm_mainnet: 1_101,
        polygon_zkevm_testnet: 1_442
      ]

      @type network_types ::
              :localhost
              | :ethereum_mainnet
              | :ethereum_goerli
              | :ethereum_sepolia
              | :polygon_mainnet
              | :polygon_testnet
              | :polygon_zkevm_mainnet
              | :polygon_zkevm_testnet
    end
  end
end
