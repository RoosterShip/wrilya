defmodule Account.Storage do
  @moduledoc """
  """

  # ----------------------------------------------------------------------------
  # Module Require
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Aliases
  # ----------------------------------------------------------------------------
  alias Account.Storage.User

  # ----------------------------------------------------------------------------
  # Module Types
  # ----------------------------------------------------------------------------
  @type user :: %User.Record{}

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  # ----------------------------------------------------------------------------
  # User Actions
  # ----------------------------------------------------------------------------

  # @doc """
  # Query a list of all registered users in the system.  This should only be used
  # for debugging purposes.
  # """
  # @spec users() :: [user()]
  def users(), do: User.list()

  # @doc """
  # Query a paginated list of users.  Please refer to the FLOP documentation
  # on how to use this correctly.
  # """
  # @spec users(params :: map) ::
  #        {:ok, {[user()], Flop.Meta.t()}}
  #        | {:error, Flop.Meta.t()}
  def users(params), do: User.paginated(params)

  # @doc """
  # Query a specific user in the system by it's ID
  # """
  # @spec user(id :: UUID.t()) :: nil | user()
  def user(id), do: User.get(id)

  # @doc """
  # Query a specific user in the system by it's ID.  If the user
  # does not exist an exception is thrown
  # """
  # @spec user!(id :: UUID.t()) :: user()
  def user!(id), do: User.get!(id)

  # @doc """
  # Query a user based on it's auth_id, auth type and user type
  # """
  # @spec user(
  #        auth_id :: String.t(),
  #        auth_type :: auth_types(),
  #        user_type :: user_types()
  #      ) ::
  #        nil | user()
  def user(auth_id, auth_type, user_type),
    do: User.lookup(auth_id, auth_type, user_type)

  # @doc """
  # Query a user based on it's auth_id, auth type and user type.

  # raises exception if not found
  # """
  # @spec user!(
  #        auth_id :: String.t(),
  #        auth_type :: auth_types(),
  #        user_type :: user_types()
  #      ) ::
  #        nil | user()
  def user!(auth_id, auth_type, user_type),
    do: User.lookup!(auth_id, auth_type, user_type)

  # @doc """
  # Create a new user in the system.  This assumes that the map passed in
  # contains the field names defined in `Storage.User.Record`

  ## Example:

  # ```
  # Storage.user_new(%{
  #  type: type,
  #  auth_id: :crypto.hash(:sha256, auth_id) |> Base.encode64(),
  #  auth_type: auth_type,
  #  email: email,
  #  avatar: avatar,
  #  meta: meta
  # })
  # ```
  # """
  # @spec user_new(map() | Ecto.Changeset.t()) ::
  #        {:ok, user()} | {:error, Ecto.Changeset.t()}
  def user_new(attrs), do: User.create(attrs)

  # @doc """
  # Update the user record with the values defined in the attrs map
  # """
  # @spec user_update(user :: UUID.t() | user(), attrs :: map() | keyword()) ::
  #        {:ok, user()}
  #        | {:error, Ecto.Changeset.t() | :cannot_change_id}
  def user_update(user, attrs),
    do: User.update_for(user, attrs)

  # @doc """
  # Delete any application from the system.

  # Note:  If you try to delete the system app an exception will be thrown
  # """
  # @spec user_delete(user :: UUID.t() | user()) ::
  #        {:ok, user()} | {:error, Ecto.Changeset.t()}
  def user_delete(user), do: User.delete_for(user)
end
