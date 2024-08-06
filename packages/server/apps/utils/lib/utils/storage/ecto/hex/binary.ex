defmodule Utils.Storage.Ecto.Hex.Binary do
  @moduledoc """
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ecto.Type

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------
  @doc """
  """
  @spec type() :: :binary
  def type, do: :binary

  @doc """
  """
  @spec cast(String.t() | binary()) :: {:ok, binary()}
  def cast(<<"0x", val::binary>>) do
    {:ok, Base.decode16!(val, case: :mixed)}
  end

  def cast(<<"0X", val::binary>>) do
    {:ok, Base.decode16!(val, case: :mixed)}
  end

  def cast(val) when is_binary(val) do
    {:ok, val}
  end

  @doc """
  """
  @spec dump(data :: binary()) :: {:ok, binary()}
  def dump(data) do
    {:ok, data}
  end

  @doc """
  """
  @spec load(data :: binary()) :: {:ok, String.t()}
  def load(data) do
    {:ok, "0x" <> Base.encode16(data, case: :lower)}
  end
end
