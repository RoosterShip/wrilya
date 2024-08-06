defmodule Faucet.Storage.Source.Record do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Faucet.Types
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
    filterable: [:id, :type, :reservoir_id],
    sortable: [:id, :type, :reservoir_id],
    default_order: %{
      order_by: [:type],
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
             :type,
             :window_size,
             :drip_amount,
             :drips_per_window,
             :receiver_max_balance,
             :receiver_drips_per_window,
             :reservoir_id
           ]}

  # ----------------------------------------------------------------------------
  # Module Schema
  # ----------------------------------------------------------------------------
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sources" do
    field(:type, Ecto.Enum, values: @source_types)
    field(:active, :boolean)
    field(:window_size, :integer)
    field(:drip_amount, :integer)
    field(:drips_per_window, :integer)
    field(:receiver_max_balance, :integer)
    field(:receiver_drips_per_window, :integer)
    field(:reservoir_id, :binary_id)
    has_many(:keys, Faucet.Storage.Key.Record, foreign_key: :source_id)
    timestamps()
  end

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @new_keys [
    :id,
    :active,
    :type,
    :window_size,
    :drip_amount,
    :drips_per_window,
    :receiver_max_balance,
    :receiver_drips_per_window,
    :reservoir_id
  ]
  @required_keys [
    :type,
    :window_size,
    :drip_amount,
    :drips_per_window,
    :receiver_max_balance,
    :receiver_drips_per_window
  ]
  @update_keys [
    :active,
    :window_size,
    :drip_amount,
    :drips_per_window,
    :receiver_max_balance,
    :receiver_drips_per_window,
    :reservoir_id
  ]

  @max_drips_total_per_window 10_000_000
  @min_window_size 60
  @max_window_size 24 * 60 * 60 * 30

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_validate(inst) do
    inst
    |> Utils.Storage.Ecto.Validator.uuid(:id)
    |> Ecto.Changeset.validate_number(:window_size,
      greater_than_or_equal_to: @min_window_size,
      less_than_or_equal_to: @max_window_size
    )
    |> Ecto.Changeset.validate_number(:drip_amount,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: @max_ecto_integer
    )
    |> Ecto.Changeset.validate_number(:drips_per_window,
      greater_than: 0,
      less_than_or_equal_to: @max_drips_total_per_window
    )
    |> Ecto.Changeset.validate_number(:receiver_max_balance,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: @max_ecto_integer
    )
    |> Ecto.Changeset.validate_number(:receiver_drips_per_window,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: @max_window_size
    )
    |> Utils.Storage.Ecto.Validator.uuid(:reservoir_id)
    |> unique_constraint(:id, name: :sources_pkey)
  end

  # ----------------------------------------------------------------------------
  # Bring in the Standard Record functions.
  # NOTE: Because of the way struct definition works, etc we must
  #       include this at the bottom of the file
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdRecord
end
