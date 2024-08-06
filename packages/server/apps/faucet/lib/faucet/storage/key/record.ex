defmodule Faucet.Storage.Key.Record do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Utils.Types
  use Ecto.Schema

  # ----------------------------------------------------------------------------
  # Module imports
  # ----------------------------------------------------------------------------
  import Ecto.Changeset

  # ----------------------------------------------------------------------------
  # Module Flop
  # ----------------------------------------------------------------------------
  @derive {
    Flop.Schema,
    filterable: [:id, :source_id, :type, :active],
    sortable: [:id, :source_id, :type, :active],
    default_order: %{
      order_by: [:id],
      order_directions: [:asc, :desc]
    },
    default_limit: 10,
    max_limit: 20
  }

  # ----------------------------------------------------------------------------
  # Module JSON
  # ----------------------------------------------------------------------------
  @derive {Jason.Encoder,
           only: [
             :id,
             :source_id,
             :type,
             :active
           ]}

  # ----------------------------------------------------------------------------
  # Module Schema
  # ----------------------------------------------------------------------------
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "keys" do
    belongs_to(:source, Faucet.Storage.Source.Record)
    field(:type, Ecto.Enum, values: @key_types)
    field(:key, Faucet.Storage.Ecto.EncryptedBinary)
    field(:active, :boolean)
    timestamps()
  end

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @new_keys [
    :id,
    :source_id,
    :type,
    :key,
    :active
  ]
  @required_keys [
    :source_id,
    :type,
    :key
  ]
  @update_keys [
    :active
  ]

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_validate(inst) do
    inst
    |> Utils.Storage.Ecto.Validator.uuid(:id)
    |> Utils.Storage.Ecto.Validator.uuid(:source_id)
    |> unique_constraint(:id, name: :keys_pkey)
  end

  # ----------------------------------------------------------------------------
  # Bring in the Standard Record functions.
  # NOTE: Because of the way struct definition works, etc we must
  #       include this at the bottom of the file
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdRecord
end

# ------------------------------------------------------------------------------
# Inspect Implementation
# ------------------------------------------------------------------------------
defimpl Inspect, for: Faucet.Storage.Key.Record do
  @moduledoc """
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Utils.Types

  # ----------------------------------------------------------------------------
  # Module Public Functions
  # ----------------------------------------------------------------------------

  @doc """
  Redacting the key info
  """
  @spec inspect(%Faucet.Storage.Key.Record{}, %Inspect.Opts{}) :: String.t()
  def inspect(
        %Faucet.Storage.Key.Record{
          id: id,
          source_id: source_id,
          type: type,
          key: key,
          active: active,
          updated_at: updated_at,
          inserted_at: inserted_at
        },
        _opts
      ) do
    obj = Utils.Key.build(type, key)

    """
    %Faucet.Storage.Key.Record{
      id: \"#{id}\",
      source_id: \"#{source_id}\",
      type: \"#{type}\",
      private_key: \"redacted\"
      <private_key_address>: \"#{Utils.Key.address_string(obj)}\",
      active: #{active},
      updated_at: #{updated_at},
      inserted_at: #{inserted_at}
    }
    """
  end
end
