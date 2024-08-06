defmodule Utils do
  @moduledoc """
  Documentation for `Utils`.
  """

  require Logger

  use Utils.Types

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the debug logs

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_debug("Step 1")
  |> step_2()
  |> pipe_debug("Step 2")
  |> step_3()
  |> pipe_debug("Step 3")
  ```
  """
  @spec pipe_debug(any, String.t()) :: any
  def pipe_debug(obj, header) do
    Logger.debug("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the info logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_info("Step 1")
  |> step_2()
  |> pipe_info("Step 2")
  |> step_3()
  |> pipe_info("Step 3")
  ```
  """
  @spec pipe_info(any, String.t()) :: any
  def pipe_info(obj, header) do
    Logger.info("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the warning logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_warn("Step 1")
  |> step_2()
  |> pipe_warn("Step 2")
  |> step_3()
  |> pipe_warn("Step 3")
  ```
  """
  @spec pipe_warn(any, String.t()) :: any
  def pipe_warn(obj, header) do
    Logger.warning("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the error logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_error("Step 1")
  |> step_2()
  |> pipe_error("Step 2")
  |> step_3()
  |> pipe_error("Step 3")
  ```
  """
  @spec pipe_error(any, String.t()) :: any
  def pipe_error(obj, header) do
    Logger.error("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  # ----------------------------------------------------------------------------
  # Filters for structs
  # ----------------------------------------------------------------------------

  @doc """
  Filters a Map or Keyword into a keyword list
  """
  @spec filter_to_keyword(map() | keyword(), [term()]) ::
          Keyword.t()
  def filter_to_keyword(attrs, filter_keys) do
    Enum.reduce(attrs, [], fn {key, value}, acc ->
      if Enum.member?(filter_keys, key) do
        Keyword.put(acc, key, value)
      else
        acc
      end
    end)
  end

  @doc """
  Filters a Map or Keyword into a Map
  """
  @spec filter_to_map(map() | keyword(), [term()]) ::
          Keyword.t()
  def filter_to_map(attrs, filter_keys) do
    Enum.reduce(attrs, %{}, fn {key, value}, acc ->
      if Enum.member?(filter_keys, key) do
        Map.put(acc, key, value)
      else
        acc
      end
    end)
  end

  # ----------------------------------------------------------------------------
  # Hex Data Tools
  # ----------------------------------------------------------------------------

  @doc """
  convert a hex string into a binary value
  """
  @spec hex_to_bin(String.t()) :: binary()
  def hex_to_bin("0x" <> val), do: hex_to_bin(val)
  def hex_to_bin("0X" <> val), do: hex_to_bin(val)
  def hex_to_bin(val), do: Base.decode16!(val, case: :mixed)

  @doc """
  Convert a BINARY value to a hex string.  This uses base 16 encoding
  """
  @spec bin_to_hex(binary()) :: String.t()
  def bin_to_hex(val), do: "0x" <> (val |> Base.encode16(case: :lower))

  # ----------------------------------------------------------------------------
  # UUID Based Public APs
  # ----------------------------------------------------------------------------

  @doc """
  Generates a random version 4 UUID in String Format
  """
  @spec uuid_str() :: uuid()
  def uuid_str(), do: Ecto.UUID.generate()

  @doc """
  Generates a random version 4 UUID in Binary Form
  """
  @spec uuid_bin() :: Ecto.UUID.raw()
  def uuid_bin(), do: Ecto.UUID.bingenerate()

  @doc """
  Convert a string rep UUID into a binary form
  """
  @spec uuid_to_bin!(uuid :: uuid()) :: Ecto.UUID.raw()
  def uuid_to_bin!(uuid), do: Ecto.UUID.dump!(uuid)

  @doc """
  Convert a string rep UUID into a String form
  """
  @spec uuid_to_str!(uuid :: Ecto.UUID.raw()) :: uuid()
  def uuid_to_str!(uuid), do: Ecto.UUID.cast!(uuid)

  @doc """
  Check to see if the provided UUID is in fact a UUID
  """
  @spec uuid?(uuid :: uuid()) :: boolean
  def uuid?(uuid), do: :error != Ecto.UUID.dump(uuid)

  @doc """
  Creates a new UUID and hex encodes it.  This is useful for sharing UUIDs with
  other systems like Solidity
  """
  @spec uuid_hex_encode!() :: String.t()
  def uuid_hex_encode!() do
    "0x" <> Base.encode16(Ecto.UUID.bingenerate(), case: :lower)
  end

  @doc """
  Encodes an existing UUID into a hex string.  This is useful for sharing UUIDs
  with other systems like Solidity
  """
  @spec uuid_hex_encode!(uuid()) :: String.t()
  def uuid_hex_encode!(uuid),
    do: "0x" <> (uuid_to_bin!(uuid) |> Base.encode16(case: :lower))

  @doc """
  Convert a UUID from a hex rep using the default "mixed" string case.
  NOTE: This can be a BIT more expensive then say using :lower or :upper
        but this should be a rare case where this is the major bottle neck

  DEV:  This function will throw an exception if the hex value can not be
        converted into a UUID string format
  """
  @spec uuid_hex_decode!(String.t()) :: uuid()
  def uuid_hex_decode!(uuid), do: uuid_hex_decode!(uuid, case: :mixed)

  @doc """
  Convert a UUID from a hex rep using the default "mixed" string case.

  DEV:  This function will throw an exception if the hex value can not be
        converted into a UUID string format
  """
  @spec uuid_hex_decode!(String.t(), [{:case, :upper | :lower | :mixed}]) :: uuid()
  def uuid_hex_decode!("0x" <> uuid, opts),
    do: uuid_hex_decode!(uuid, opts)

  def uuid_hex_decode!("0X" <> uuid, opts),
    do: uuid_hex_decode!(uuid, opts)

  def uuid_hex_decode!(uuid, opts),
    do: Base.decode16!(uuid, opts) |> uuid_to_str!()

  # ----------------------------------------------------------------------------
  # Key Based Generators
  # ----------------------------------------------------------------------------

  @doc """
  Check if the provided value is in blockchain address format
  """
  @spec address?(address :: String.t() | binary) :: boolean()
  def address?("0x" <> address), do: address?(address)
  def address?("0X" <> address), do: address?(address)

  def address?(<<_::size(320)>> = address),
    do: Base.decode16!(address, case: :mixed) |> address?

  def address?(<<_::size(160)>>), do: true
  def address?(_), do: false

  @doc """
  Simple check to see if the struct given is of a Key type.

  NOTE: This was really meant for unit testing and will have some performance overhead
  """
  @spec key?(term()) :: boolean
  def key?(key), do: Utils.Key.of_type?(key)

  @doc """
  Construct a new Key Structure using a randomly create key.

  Note:  The `type` atom can be of value `chain_type()` or `key_types()`
  """
  @spec key!(type :: atom()) :: Utils.Key.Protocol.t()
  def key!(type \\ :secp256k1), do: Utils.Key.build(type)

  @doc """
  """
  @spec key!(
          priv_key :: String.t() | binary(),
          type :: atom()
        ) :: Utils.Key.Protocol.t()
  def key!(priv_key, type), do: Utils.Key.build(type, priv_key)

  @doc """
  """
  @spec key!(
          priv_key :: String.t() | binary(),
          pub_key :: String.t() | binary(),
          type :: atom()
        ) :: Utils.Key.Protocol.t()
  def key!(priv_key, pub_key, type), do: Utils.Key.build(type, priv_key, pub_key)

  @doc """
  Get the Key type for a struct
  """
  @spec key_type!(key :: Utils.Key.Protocol.t()) :: key_types()
  def key_type!(key), do: Utils.Key.type(key)

  @doc """
  Check if the struct is a key
  """
  @spec key_struct?(term()) :: boolean
  def key_struct?(key), do: Utils.Key.of_type?(key)

  @doc """
  Get the address of this key in the form of a encoded string
  """
  @spec key_address_string(Utils.Key.Protocol.t()) :: String.t()
  def key_address_string(obj), do: Utils.Key.address_string(obj)

  @doc """
  Get the public_key of this key in the form of a encoded string
  """
  @spec key_public_string(Utils.Key.Protocol.t()) :: String.t()
  def key_public_string(obj), do: Utils.Key.public_key_string(obj)

  @doc """
  Get the private_key of this key in the form of a encoded string
  """
  @spec key_private_string(Utils.Key.Protocol.t()) :: String.t()
  def key_private_string(obj), do: Utils.Key.private_key_string(obj)

  @doc """
  Sign a block of data. signature returned based on the key type used
  """
  @spec key_sign(Utils.Key.Protocol.t(), binary()) :: {:ok, term()} | {:error, term()}
  def key_sign(obj, data), do: Utils.Key.sign(obj, data)

  # ----------------------------------------------------------------------------
  # Module Macros
  # ----------------------------------------------------------------------------

  @doc """
  Get the key type for a given chain type.
  """
  @spec chain_key_type(chain_types() | %{type: chain_types()}) :: key_types()
  def chain_key_type(:ethereum), do: :secp256k1
  def chain_key_type(:polygon), do: :secp256k1
  def chain_key_type(:polygon_zkevm), do: :secp256k1
  def chain_key_type(:avalanche), do: :secp256k1
  def chain_key_type(:linea), do: :secp256k1
  def chain_key_type(:zksync), do: :secp256k1
  def chain_key_type(:sol), do: :ed25519
  def chain_key_type(:near), do: :ed25519
  def chain_key_type(:xrpl), do: :ed25519
  def chain_key_type(:aleo), do: :ed25519
  def chain_key_type(%{type: type}), do: chain_key_type(type)

  # ----------------------------------------------------------------------------
  # Module Macros
  # ----------------------------------------------------------------------------

  @doc """
  Sometime it just gets annoying to have to case calls that we want to throw
  an exception and just let it fail.  This call cleans up the code in those
  cases.  It is JUST syntax sugar for a case statement.
  """
  @spec unwrap!(any()) :: {:case, [{:column, 7} | {:do, [...]} | {:end, [...]}, ...], [...]}
  defmacro unwrap!(call) do
    quote do
      case unquote(call) do
        {:ok, unwrapped_value} -> unwrapped_value
        _ -> raise "Unwrap failure"
      end
    end
  end
end
