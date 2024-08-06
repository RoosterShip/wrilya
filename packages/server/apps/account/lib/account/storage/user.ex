defmodule Account.Storage.User do
  @moduledoc """
  The Chain context.
  """

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Utils.Storage.StdCRUD, context: Account.Storage.User.Record, repo: Account.Repo

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  # @doc """
  # """
  # @spec lookup(
  #        auth_id :: String.t(),
  #        auth_type :: auth_types(),
  #        user_type :: user_types()
  #      ) ::
  #        nil | %Record{}
  def lookup(auth_id, auth_type, user_type) do
    from(u in Record,
      where: u.auth_id == ^auth_id and u.auth_type == ^auth_type and u.type == ^user_type
    )
    |> Repo.one()
  end

  # @doc """
  # """
  # @spec lookup!(
  #        auth_id :: String.t(),
  #        auth_type :: auth_types(),
  #        user_type :: user_types()
  #      ) ::
  #        nil | %Record{}
  def lookup!(auth_id, auth_type, user_type) do
    from(u in Record,
      where: u.auth_id == ^auth_id and u.auth_type == ^auth_type and u.type == ^user_type
    )
    |> Repo.one!()
  end
end
