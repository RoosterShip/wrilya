defmodule Wrilya.Chain.Notification.VoidsmanCertify do
  use  Wrilya.Chain.Notification.Operations
  defmacro __using__(_opts) do
    quote do
      def handle(unquote(@voidsman_certify), nid, data) do

        Wrilya.Discord.publish("""
        # Onchain Event: Voidsman Certify

        operation nonce: #{nid}
        operation data: #{data}
        """)

        :ok
      end
    end
  end
end
