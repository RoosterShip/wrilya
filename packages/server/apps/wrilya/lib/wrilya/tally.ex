defmodule Wrilya.Tally do
  @moduledoc """
  Interface for communicating with Tally.xyz.

  Tally is a DAO governance tool with a GraphQL API which can query and interact
  with DAOs deployed on a public blockchain.
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Public API
  # ----------------------------------------------------------------------------

  @doc """
  Pulls the list of proposals from tally based on a status type.

  # Expected Arguments:
  type:  "PENDING" | "ACTIVE" | "PASSED" | "DEFEATED"
  chain_id:  "eip115" <> "blockchain number".  "eip155:1115511"
  governors: [Address of contract]. List of contract addresses to query

  # Returns:

  List of Map structs with proposal data

  If there is some kind of network or data an error an exception will be raised
  """
  @spec fetch_proposals!(
          type :: String.t(),
          chain_id :: UUID.t(),
          governors :: [String.t()]
        ) :: [map()]
  def fetch_proposals!(type, chain_id, governors) do
    {:ok, res, _headers} =
      GQL.query(
        """
        query Proposals(
          $chain_id: ChainID!,
          $governors: [Address!],
        ) {
          proposals(
            chainId: $chain_id,
            governors: $governors,
          ) {
            id
            title
            description
            statusChanges {
              type
            }
          }
        }
        """,
        headers: [
          {"Content-Type", "application/json"},
          {"Api-Key", Application.get_env(:wrilya, :tally_key, "064e8b8c8d33eb22382d76e2faaf470b2f107f3a3d904a2e6dd9dfde68eae67a")}
        ],
        url: "https://api.tally.xyz/query",
        variables: [
          chain_id: chain_id,
          governors: governors
        ]
      )

    Enum.reduce(res["data"]["proposals"], [], fn proposal, acc ->
      if List.last(proposal["statusChanges"]) == %{"type" => type} do
        [%{title: proposal["title"], description: proposal["description"]} | acc]
      else
        acc
      end
    end)
  end
end
