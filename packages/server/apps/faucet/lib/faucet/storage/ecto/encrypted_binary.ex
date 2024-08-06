defmodule Faucet.Storage.Ecto.EncryptedBinary do
  @moduledoc """
  Cloak based ecto type which will store binary values via an AES encrypted
  field so that sensitive data is NOT stored in the clear
  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Cloak.Ecto.Binary, vault: Faucet.Vault
end
