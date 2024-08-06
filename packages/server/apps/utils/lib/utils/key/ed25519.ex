defmodule Utils.Key.ED25519 do
  @moduledoc """
  Struct for holding a ED25519 based key pairs.

  This module uses elixir protocols to direct a struct to a specific implementation
  """

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @key_size 32
  @key_len 256

  # ----------------------------------------------------------------------------
  # Module Require
  # ----------------------------------------------------------------------------
  require Logger
  require Utils

  # ----------------------------------------------------------------------------
  # Module types
  # ----------------------------------------------------------------------------
  @type key_t :: <<_::256>>
  @type t :: %Utils.Key.ED25519{
          private: key_t(),
          public: key_t(),
          address: key_t()
        }

  # ----------------------------------------------------------------------------
  # Module Struct
  # ----------------------------------------------------------------------------
  defstruct private: <<>>, public: <<>>, address: <<>>

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  """
  @spec build() :: t()
  def build() do
    :crypto.strong_rand_bytes(@key_size)
    |> build()
  end

  @doc """
  Creates a Key Struct from an existing private key
  """
  @spec build(String.t() | key_t()) :: t()
  def build(<<_::@key_len>> = priv_key) do
    pub_key = Ed25519.derive_public_key(priv_key)
    build(priv_key, pub_key)
  end

  def build(priv_key) do
    true = String.valid?(priv_key)
    build(ExBase58.decode(priv_key) |> Utils.unwrap!())
  end

  @doc """
  Creates a Key Struct from and existing private and public key
  """
  @spec build(String.t() | key_t(), String.t() | key_t()) :: t()
  def build(priv_key, pub_key) do
    priv_key =
      if(String.valid?(priv_key)) do
        ExBase58.decode(priv_key) |> Utils.unwrap!()
      else
        priv_key
      end

    pub_key =
      if(String.valid?(pub_key)) do
        ExBase58.decode(pub_key) |> Utils.unwrap!()
      else
        pub_key
      end

    do_build(priv_key, pub_key)
  end

  @doc """
  Signs a block of data.  This will keccak hash the value first
  """
  @spec sign(key_t(), key_t(), binary()) :: {:ok, binary()}
  def sign(private_key, public_key, data) do
    sig = Ed25519.signature(data, private_key, public_key)
    {:ok, sig}
  end

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_build(<<_::@key_len>> = priv_key, <<_::@key_len>> = pub_key) do
    %Utils.Key.ED25519{
      private: priv_key,
      public: pub_key,
      address: pub_key
    }
  end
end

# ----------------------------------------------------------------------------
# Inspect Implementation
# ----------------------------------------------------------------------------
defimpl Inspect, for: Utils.Key.ED25519 do
  @moduledoc """
  Implementation for the Inspect function for a Utils.Key.ED25519 struct
  """

  # --------------------------------------------------------------------------
  # Module Public Functions
  # --------------------------------------------------------------------------

  @doc """
  Callback for the inspect.  This is where the struct is transformed into into
  a string which will be sent to the output stream buffer.
  """
  @spec inspect(Utils.Key.ED25519.t(), %Inspect.Opts{}) :: String.t()
  def inspect(%Utils.Key.ED25519{public: public}, _opts) do
    """
    %Utils.Key.ED25519{
      public key: \"#{ExBase58.encode!(public)}\",
      private_key: \"redacted\"
    }
    """
  end
end

# ----------------------------------------------------------------------------
# Utils.Key.Protocol Implementation
# ----------------------------------------------------------------------------
defimpl Utils.Key.Protocol, for: Utils.Key.ED25519 do
  @moduledoc """
  Implementation of the protocol functions needed for the Keys
  """

  # --------------------------------------------------------------------------
  # Module Requires
  # --------------------------------------------------------------------------
  require Utils

  # --------------------------------------------------------------------------
  # Module Public Functions
  # --------------------------------------------------------------------------

  @doc """
  Get the private key in the form of a Base58 encoded string.  For this
  version the public key and the address are the same.
  """
  @spec address_string(Utils.Key.ED25519.t()) :: binary()
  def address_string(obj), do: ExBase58.encode(Map.get(obj, :address)) |> Utils.unwrap!()

  @doc """
  Get the public key in the form of a Base58 encoded string.
  """
  @spec public_key_string(Utils.Key.ED25519.t()) :: binary()
  def public_key_string(obj), do: ExBase58.encode(Map.get(obj, :public)) |> Utils.unwrap!()

  @doc """
  Get the private key in the form of a Base58 encoded string.
  """
  @spec private_key_string(Utils.Key.ED25519.t()) :: binary()
  def private_key_string(obj), do: ExBase58.encode(Map.get(obj, :private)) |> Utils.unwrap!()

  @doc """
  Sign a block of data using ED25519 curve with the private key
  """
  @spec sign(Utils.Key.ED25519.t(), binary()) :: {:ok, binary()}
  def sign(obj, val),
    do: Utils.Key.ED25519.sign(Map.get(obj, :private), Map.get(obj, :public), val)
end
