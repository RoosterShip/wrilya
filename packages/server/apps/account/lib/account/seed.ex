defmodule Account.Seed do
  @moduledoc """
  Documentation for `Account`.
  """

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  # @permissions [
  #   %{
  #     title: "Admin Site",
  #     slug: :admin_site,
  #     active: true,
  #     description: """
  #     Enables user access to the Admin Site.  This only allows access to the
  #     site while site operations will have their own permission.
  #     """
  #   },
  #   %{
  #     title: "Admin Users",
  #     slug: :admin_users,
  #     active: true,
  #     description: """
  #     Enables access to the user adminstration commands.
  #     """
  #   },
  #   %{
  #     title: "Admin Faucet",
  #     slug: :admin_faucet,
  #     active: true,
  #     description: """
  #     Enables access to the system wallet faucet commands.
  #     """
  #   },
  #   %{
  #     title: "Admin Faucet",
  #     slug: :admin_faucet,
  #     active: true,
  #     description: """
  #     Enables access to the system wallet faucet commands.
  #     """
  #   },
  #   %{
  #     title: "Admin Chains",
  #     slug: :admin_chains,
  #     active: true,
  #     description: """
  #     Enables administration to the system registered chains.
  #     """
  #   },
  #   %{
  #     title: "Admin Chains",
  #     slug: :admin_chains,
  #     active: true,
  #     description: """
  #     Enables administration to the system registered chains.
  #     """
  #   }
  # ]

  # ----------------------------------------------------------------------------
  # Module Public API
  # ----------------------------------------------------------------------------

  @doc """
  Registered all the system defined permissions.  This function
  can be called multiple times if needed but it will not replace
  any existing permissions with a matching slug
  """
  @spec run() :: :ok
  def run do
    # Enum.each(@permissions, fn record ->
    #   try do
    #     Storage.permission_new(record)
    #   rescue
    #     _e in Ecto.ConstraintError ->
    #       :ok
    #   end
    # end)
    :ok
  end
end
