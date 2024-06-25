defmodule Wrilya.Chain.Worker do
  require Logger
  use Oban.Pro.Worker

  args_schema do
    field :op,  :integer, required: true
    field :nid,  :string, required: true
    field :data,  :string, required: true
  end

  @impl Oban.Pro.Worker
  def process(%Job{args: %__MODULE__{op: op, nid: nid, data: data}}) do
    _ = Wrilya.Chain.Notification.handle(op, nid, data)
    :ok
  rescue
    exception ->
      Logger.error("[Wrilya.Chain.Worker] Exception: #{inspect exception, structs: false, pretty: true }")
      :ok
  end
end
