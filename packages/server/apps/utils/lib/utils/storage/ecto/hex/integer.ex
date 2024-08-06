defmodule Utils.Storage.Ecto.Hex.Integer do
  @moduledoc """
  Blockchains support some crazy high number spaces like the insain uint256.
  To keep number that high in the DB we will convert them to a binary rep.
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
  @spec type() :: :string
  def type, do: :string

  @doc """
  """
  @spec cast(integer() | String.t()) :: {:ok, String.t()} | :error
  def cast(value) when is_integer(value) do
    {:ok, "0x" <> Integer.to_string(value, 16)}
  end

  def cast(<<"0x", val::binary>>), do: do_cast(val)
  def cast(<<"0X", val::binary>>), do: do_cast(val)
  def cast(<<val::binary>>), do: do_convert(val)

  @doc """
  """
  @spec load(data :: String.t()) :: {:ok, String.t()}
  def load(data), do: {:ok, data}

  @doc """
  """
  @spec dump(data :: String.t()) :: {:ok, String.t()}
  def dump(data), do: {:ok, data}

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_cast(val) do
    case Integer.parse(val, 16) do
      {_val, ""} -> {:ok, "0x" <> val}
      {_val, _} -> :error
    end
  end

  defp do_convert(val) do
    case Integer.parse(val, 10) do
      {val, ""} ->
        {:ok, ("0x" <> Integer.to_string(val, 16)) |> String.downcase()}

      {_val, _} ->
        :error
    end
  end
end
