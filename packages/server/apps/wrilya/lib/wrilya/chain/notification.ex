defmodule Wrilya.Chain.Notification do
  require Logger

  use Wrilya.Chain.Notification.CurrencyClaim
  use Wrilya.Chain.Notification.EntityCreate
  use Wrilya.Chain.Notification.VoidsmanCertify
  def handle(oid, nid, data) do
    Logger.error("Unknown Value: #{inspect {oid, nid, data}}")
  end
end
