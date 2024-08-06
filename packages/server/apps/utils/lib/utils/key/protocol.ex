defprotocol Utils.Key.Protocol do
  @moduledoc """
  Protocol Interface for a Crypto public/private key pair.  This protocol
  defines the "actions" you can do with the key, not how the data is stored
  and/or accessed, etc.
  """

  @doc """
  Get the key address from the key object
  """
  @spec address_string(t()) :: String.t()
  def address_string(obj)

  @doc """
  Get the public key value in a hex encoded string
  """
  @spec public_key_string(t()) :: String.t()
  def public_key_string(obj)

  @doc """
  Get the private key value in a hex encoded string
  """
  @spec private_key_string(t()) :: String.t()
  def private_key_string(obj)

  @doc """
  signs a block of data using a standard "signature" method for the keys.

  NOTE: Many blockchains have a custom formating they expect to use
        when generating a signature.  As such this function might
        not be used depending on the blockchain/etc.
  """
  @spec sign(t(), binary()) :: {:ok, term()} | {:error, term()}
  def sign(obj, data)
end
