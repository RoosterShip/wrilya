defmodule Faucet.Storage.Drip.Record do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ecto.Schema

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @max_drip_value 9_223_372_036_854_775_807

  # ----------------------------------------------------------------------------
  # Module imports
  # ----------------------------------------------------------------------------
  import Ecto.Changeset

  # ----------------------------------------------------------------------------
  # Module Flop
  # ----------------------------------------------------------------------------
  @derive {
    Flop.Schema,
    filterable: [:address],
    sortable: [:address],
    default_order: %{
      order_by: [:address],
      order_directions: [:asc, :desc]
    },
    default_limit: 10,
    max_limit: 20
  }

  # ----------------------------------------------------------------------------
  # Module JSON
  # ----------------------------------------------------------------------------
  @derive {Jason.Encoder, only: [:id, :address, :amount]}

  # ----------------------------------------------------------------------------
  # Module Schema
  # ----------------------------------------------------------------------------
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drips" do
    belongs_to(:source, Faucet.Storage.Source.Record)
    field(:address, Utils.Storage.Ecto.Hex.Binary)
    field(:amount, :integer)
    timestamps()
  end

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @new_keys [:id, :source_id, :address, :amount]
  @required_keys [:source_id, :address, :amount]
  @update_keys []

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_validate(inst) do
    inst
    |> Ecto.Changeset.validate_number(:amount, less_than: @max_drip_value)
    |> Utils.Storage.Ecto.Validator.address(:address)
    |> Utils.Storage.Ecto.Validator.uuid(:source_id)
  end

  # ----------------------------------------------------------------------------
  # Bring in the Standard Record functions.
  # NOTE: Because of the way struct definition works, etc we must
  #       include this at the bottom of the file
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdRecord
end
