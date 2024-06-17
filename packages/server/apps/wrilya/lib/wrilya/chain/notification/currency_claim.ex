defmodule Wrilya.Chain.Notification.CurrencyClaim do
  use  Wrilya.Chain.Notification.Operations
  defmacro __using__(_opts) do
    quote do
      def handle(unquote(@currency_claim), _nid, _data) do
        Logger.debug("Currency Claim Happed!!!!")
      end
    end
  end
end
