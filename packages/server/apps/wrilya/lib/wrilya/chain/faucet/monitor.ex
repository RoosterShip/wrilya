defmodule Wrilya.Chain.Faucet.Monitor do
  require Logger
  use Oban.Pro.Worker
  @impl Oban.Pro.Worker

  def process(%Job{} = _job) do
    Logger.debug("**** FAUCET MONITOR CALLED")
  end
end
