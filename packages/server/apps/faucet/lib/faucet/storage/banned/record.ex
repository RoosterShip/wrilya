defmodule Faucet.Storage.Banned.Record do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
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
  @derive {Jason.Encoder, only: [:id, :address]}

  # ----------------------------------------------------------------------------
  # Module Schema
  # ----------------------------------------------------------------------------
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "banned" do
    belongs_to(:source, Faucet.Storage.Source.Record)
    field(:address, Utils.Storage.Ecto.Hex.Binary)
    timestamps()
  end

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @new_keys [:id, :address, :source_id]
  @required_keys [:address, :source_id]
  @update_keys []

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_validate(inst) do
    inst
    |> Utils.Storage.Ecto.Validator.uuid(:source_id)
    |> Utils.Storage.Ecto.Validator.address(:address)
  end

  # ----------------------------------------------------------------------------
  # Bring in the Standard Record functions.
  # NOTE: Because of the way struct definition works, etc we must
  #       include this at the bottom of the file
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdRecord
end
