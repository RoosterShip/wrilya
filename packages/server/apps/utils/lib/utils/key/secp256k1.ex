defmodule Utils.Key.Secp256K1 do
  @moduledoc """
  Struct for holding a SECP256K1 key
  """

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @priv_key_size 32
  @priv_key_len 256
  # @pub_key_size 65
  @pub_key_len 520
  @address_size 20
  # @address_len 160
  @address_offset 12

  # ----------------------------------------------------------------------------
  # Module Require
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module types
  # ----------------------------------------------------------------------------
  @type priv_key_t :: <<_::256>>
  @type pub_key_t :: <<_::520>>
  @type address_t :: <<_::160>>
  @type t :: %Utils.Key.Secp256K1{
          address: address_t(),
          private: priv_key_t(),
          public: pub_key_t()
        }

  # ----------------------------------------------------------------------------
  # Module Struct
  # ----------------------------------------------------------------------------
  defstruct address: <<>>, private: <<>>, public: <<>>

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Generate a new key for the system to use
  """
  @spec build() :: t()
  def build() do
    :crypto.strong_rand_bytes(@priv_key_size)
    |> build()
  end

  @doc """
  Creates a Key Struct from an existing private key
  """
  @spec build(String.t() | priv_key_t()) :: t()
  def build("0x" <> priv_key), do: build(Utils.hex_to_bin(priv_key))
  def build("0X" <> priv_key), do: build(Utils.hex_to_bin(priv_key))

  def build(<<_::@priv_key_len>> = priv_key) do
    {:ok, pub_key} = ExSecp256k1.create_public_key(priv_key)
    build(priv_key, pub_key)
  end

  @doc """
  Creates a Key Struct from and existing private and public key
  """
  @spec build(String.t() | priv_key_t(), String.t() | pub_key_t()) :: t()
  def build("0x" <> priv_key, pub_key), do: build(Utils.hex_to_bin(priv_key), pub_key)
  def build("0X" <> priv_key, pub_key), do: build(Utils.hex_to_bin(priv_key), pub_key)

  def build(priv_key, "0x" <> pub_key), do: build(priv_key, Utils.hex_to_bin(pub_key))
  def build(priv_key, "0X" <> pub_key), do: build(priv_key, Utils.hex_to_bin(pub_key))

  def build(<<_::@priv_key_len>> = priv_key, <<_::@pub_key_len>> = pub_key) do
    %Utils.Key.Secp256K1{
      address: to_address(pub_key),
      private: priv_key,
      public: pub_key
    }
  end

  @doc """
  Signs a block of data.  This will keccak hash the value first
  """
  @spec sign(priv_key_t(), binary()) ::
          {:error, atom()} | {:ok, {binary(), binary(), non_neg_integer()}}
  def sign(private_key, data),
    do: ExSecp256k1.sign(ExKeccak.hash_256(data), private_key)

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------

  defp to_address(public_key) do
    <<4::size(8), key::binary-size(64)>> = public_key

    <<_::binary-size(@address_offset), address::binary-size(@address_size)>> =
      ExKeccak.hash_256(key)

    address
  end
end

# ------------------------------------------------------------------------------
# Inspect Implementation
# ------------------------------------------------------------------------------
defimpl Inspect, for: Utils.Key.Secp256K1 do
  @moduledoc """
  Implementation for the Inspect function for a Utils.Key.Secp256K1 struct
  """

  # ----------------------------------------------------------------------------
  # Module Public Functions
  # ----------------------------------------------------------------------------

  @doc """
  Callback for the inspect.  This is where the struct is transformed into into
  a string which will be sent to the output stream buffer.
  """
  @spec inspect(Utils.Key.Secp256K1.t(), %Inspect.Opts{}) :: String.t()
  def inspect(
        %Utils.Key.Secp256K1{
          address: address,
          public: public
        },
        _opts
      ) do
    """
    %Utils.Key.Secp256K1{
      address: \"#{Utils.bin_to_hex(address)}\",
      public key: \"#{Utils.bin_to_hex(public)}\",
      private_key: \"redacted\"
    }
    """
  end
end

# ------------------------------------------------------------------------------
# Utils.Key.Protocol Implementation
# ------------------------------------------------------------------------------
defimpl Utils.Key.Protocol, for: Utils.Key.Secp256K1 do
  @moduledoc """
  Implementation of the protocol functions needed for the Keys
  """

  @doc """
  Get the address in the form of a Base16 encoded string.
  """
  @spec address_string(Utils.Key.Secp256K1.t()) :: binary()
  def address_string(obj), do: Utils.bin_to_hex(Map.get(obj, :address))

  @doc """
  Get the public key in the form of a Base16 encoded string.
  """
  @spec public_key_string(Utils.Key.Secp256K1.t()) :: binary()
  def public_key_string(obj), do: Utils.bin_to_hex(Map.get(obj, :public))

  @doc """
  Get the private key in the form of a Base16 encoded string.
  """
  @spec private_key_string(Utils.Key.Secp256K1.t()) :: binary()
  def private_key_string(obj), do: Utils.bin_to_hex(Map.get(obj, :private))

  @doc """
  Sign a block of data using Secp256K1 curve with the private key
  """
  @spec sign(Utils.Key.Secp256K1.t(), binary()) :: {:ok, term()} | {:error, term()}
  def sign(obj, val), do: Utils.Key.Secp256K1.sign(Map.get(obj, :private), val)
end
