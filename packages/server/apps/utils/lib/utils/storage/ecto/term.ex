defmodule Utils.Storage.Ecto.Term do
  @moduledoc """
  In some cases it is nice to be able to store an erlang/elixir term in a binary
  representation within the database.  This ecto type converter will allow
  such operations.  However the use of this data should be STORAGE purposes only.

  If you need know these values in a query then breaking them out into proper
  ecto types will be required.
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ecto.Type

  # ----------------------------------------------------------------------------
  # Module Ecto.type Behaviour Implementations
  # ----------------------------------------------------------------------------

  @doc """
  defines the ecto type this "type" will be mapped into.  For the case of an
  erlang/elixir term it will just be a binary rep.
  """
  @spec type() :: :binary
  def type, do: :binary

  @doc """
  When casting there isn't anything special we should do.  This is the callback
  for when the record is validating if the data can be sent to the DB.  Since
  we are using the awesome Term->to->Binary conversion any term can be converted
  into a binary rep.
  """
  @spec cast(any()) :: {:ok, any()}
  def cast(value), do: {:ok, value}

  @doc """
  Dump happens when are about to post the data to the database.  In that case
  the term needs to be converted into a binary representation.
  """
  @spec dump(any()) :: {:ok, binary()}
  def dump(value), do: {:ok, :erlang.term_to_binary(value)}

  @doc """
  Read the data out of the database and convert it into a term the system
  can understand.
  """
  @spec load(binary()) :: {:ok, any()}
  def load(data), do: {:ok, :erlang.binary_to_term(data)}
end
