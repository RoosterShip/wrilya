defmodule Account.Storage.User.Record do
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
    filterable: [:id, :email, :active],
    sortable: [:id, :email, :active],
    default_order: %{
      order_by: [:id, :email, :active],
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
             :auth_id,
             :auth_type,
             :email,
             :avatar,
             :active,
             :meta
           ]}

  # ----------------------------------------------------------------------------
  # Module Schema
  # ----------------------------------------------------------------------------
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:type, Ecto.Enum, values: [admin: 1, app: 2])
    field(:auth_id, Utils.Storage.Ecto.Hashed)
    field(:auth_type, Ecto.Enum, values: [google: 1, discord: 2])
    field(:email, Account.Storage.Ecto.Encrypted.Binary)
    field(:avatar, :string)
    field(:active, :boolean, default: true)
    field(:meta, :map, default: %{})
    timestamps()
  end

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @new_keys [:id, :type, :auth_id, :auth_type, :email, :avatar, :active, :meta]
  # @required_keys [:type, :auth_id, :auth_type, :email]
  @required_keys []
  @update_keys [:type, :email, :avatar, :active, :meta]

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------
  defp do_validate(inst) do
    # NOTES:
    #
    # auth_id is checked at 44 chars instead of 32 because it is in hex encoded format
    #         and will be converted into the actual DB format once processed
    #
    # avatar has a max url length of 128 because I don't want folks to blow up
    #         my DB by pushing huge blocks of text data.  128 characts should be
    #         able to cover the vast majority of URLs for an avatar image
    inst
    |> validate_length(:email, max: 128)
    |> EctoCommons.EmailValidator.validate_email(:email)
    |> validate_length(:auth_id, is: 44)
    |> validate_length(:avatar, max: 128)
    |> EctoCommons.URLValidator.validate_url(:avatar)
  end

  # ----------------------------------------------------------------------------
  # Bring in the Standard Record functions.
  # NOTE: Because of the way struct definition works, etc we must
  #       include this at the bottom of the file
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdRecord
end
