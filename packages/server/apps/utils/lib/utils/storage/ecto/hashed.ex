defmodule Utils.Storage.Ecto.Hashed do
  @moduledoc """
  """
  require Logger

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ecto.Type

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Defines the actual database storage format
  """
  @spec type() :: :binary
  def type, do: :binary

  @doc """
  """
  @spec cast(binary()) :: {:ok, binary()}
  def cast(value), do: {:ok, :crypto.hash(:sha256, value) |> Base.encode64()}

  @doc """
  """
  @spec load(data :: binary()) :: {:ok, binary()}
  def load(data), do: {:ok, Base.encode64(data)}

  @doc """
  """
  @spec dump(data :: binary()) :: {:ok, binary()}
  def dump(data), do: {:ok, data |> Base.decode64!()}
end
