defmodule Wrilya.Chain.Faucet.Drip do
  require Logger
  use Oban.Pro.Worker
  @impl Oban.Pro.Worker

  def process(%Job{} = _job) do
    Logger.debug("**** FAUCET DRIP CALLED")
  end
end
