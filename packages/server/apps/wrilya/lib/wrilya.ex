defmodule Wrilya do
  @moduledoc """
  Wrilya keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def faucet_drip(address) do
    Faucet.drip_async(address, Application.get_env(:wrilya, :faucet))
  end
end
