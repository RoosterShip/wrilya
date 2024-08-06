defmodule Account.Storage.Ecto.Encrypted.Binary do
  @moduledoc """
  Cloak based ecto type which will store binary values via an AES encrypted
  field so that sensitive data is NOT stored in the clear
  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Cloak.Ecto.Binary, vault: Account.Vault
end
