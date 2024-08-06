defmodule Utils.Key do
  @moduledoc """
  Main API for the Utils Key structs.  This should be mostly a pass through
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Utils.Types

  # ----------------------------------------------------------------------------
  # Module Types
  # ----------------------------------------------------------------------------
  @type algorithms :: chain_types() | key_types()
  @type key_data :: String.t() | binary()

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Build a Key Structure using a randomly created key
  """
  @spec build(algorithms()) :: Utils.Key.Protocol.t()
  def build(:secp256k1), do: Utils.Key.Secp256K1.build()
  def build(:ed25519), do: Utils.Key.ED25519.build()
  def build(chain_type), do: build(Utils.chain_key_type(chain_type))

  @doc """
  Build a Key Structure using a pre defined private key.
  """
  @spec build(algorithms(), priv_key :: key_data()) :: Utils.Key.Protocol.t()
  def build(:secp256k1, priv_key), do: Utils.Key.Secp256K1.build(priv_key)
  def build(:ed25519, priv_key), do: Utils.Key.ED25519.build(priv_key)
  def build(chain_type, priv_key), do: build(Utils.chain_key_type(chain_type), priv_key)

  @doc """
  Build a Key Structure using a pre defined public and private key.

  NOTE: If the public key does not match that of the private key
        and exception will be thrown
  """
  @spec build(algorithms(), priv_key :: key_data(), pub_key :: key_data()) ::
          Utils.Key.Protocol.t()
  def build(:secp256k1, priv_key, pub_key),
    do: Utils.Key.Secp256K1.build(priv_key, pub_key)

  def build(:ed25519, priv_key, pub_key),
    do: Utils.Key.ED25519.build(priv_key, pub_key)

  def build(chain_type, priv_key, pub_key),
    do: build(Utils.chain_key_type(chain_type), priv_key, pub_key)

  @doc """
  Get the Key type for a struct
  """
  @spec type(Utils.Key.Protocol.t()) :: :secp256k1 | :ed25519
  def type(%Utils.Key.Secp256K1{}), do: :secp256k1
  def type(%Utils.Key.ED25519{}), do: :ed25519

  @doc """
  Get the address of this key in the form of a encoded string
  """
  @spec address_string(Utils.Key.Protocol.t()) :: String.t()
  def address_string(obj), do: Utils.Key.Protocol.address_string(obj)

  @doc """
  Get the public_key of this key in the form of a encoded string
  """
  @spec public_key_string(Utils.Key.Protocol.t()) :: String.t()
  def public_key_string(obj), do: Utils.Key.Protocol.public_key_string(obj)

  @doc """
  Get the private_key of this key in the form of a encoded string
  """
  @spec private_key_string(Utils.Key.Protocol.t()) :: String.t()
  def private_key_string(obj), do: Utils.Key.Protocol.private_key_string(obj)

  @doc """
  Sign a block of data. signature returned based on the key type used
  """
  @spec sign(Utils.Key.Protocol.t(), binary()) :: {:ok, term()} | {:error, term()}
  def sign(obj, data), do: Utils.Key.Protocol.sign(obj, data)

  @doc """
  Simple check to see if the struct given is of a Key type.

  NOTE: This was really meant for unit testing and will have some performance overhead
  """
  @spec of_type?(term()) :: boolean
  def of_type?(val) do
    case Utils.Key.Protocol.impl_for(val) do
      Utils.Key.Protocol.Utils.Key.ED25519 ->
        true

      Utils.Key.Protocol.Utils.Key.Secp256K1 ->
        true

      _ ->
        false
    end
  end
end
