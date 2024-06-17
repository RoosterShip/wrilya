defmodule Wrilya.Chain do
  require Logger

  # def setup() do
  #   {:ok, connection} = AMQP.Connection.open
  #   {:ok, channel} = AMQP.Channel.open(connection)
  #   AMQP.Queue.declare(channel, "@wrilya_notification_queue")
  #   AMQP.Basic.consume(channel, "@wrilya_notification_queue", nil, no_ack: true)
  #   wait_for_messages()
  # end

  # defp wait_for_messages() do
  #    receive do
  #     {:basic_deliver, payload, _meta} ->
  #       _ = Task.async(fn() ->
  #         msg = Jason.decode!(payload)
  #         Wrilya.Chain.Notification.handle(msg["op"], msg["nid"], msg["data"])
  #       end)
  #       wait_for_messages()
  #   end
  # end
end
