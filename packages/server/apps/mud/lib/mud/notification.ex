defmodule MUD.Notification do
  use GenServer
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(_args) do
    Logger.debug("*** INITIALIZED")
    EctoWatch.subscribe(MUD.Data.GameNotification, :inserted)
    EctoWatch.subscribe(MUD.Data.GameNotification, :updated)
    EctoWatch.subscribe(MUD.Data.GameNotification, :deleted)
    {:ok, :ok}
  end

  @impl true
  def handle_call(Message, _from, state) do
    Logger.debug("*** HANDLE CALL")
    {:noreply, state}
  end

  @impl true
  def handle_cast(msg, state) do
    Logger.debug("*** HANDLE cast")
    {:noreply, state}
  end

  @impl true
  def handle_info({action, MUD.Data.GameNotification, id, val}, state) do
    Logger.debug("*** ACTION: #{inspect action}")
    Logger.debug("*** ID: #{inspect id}")
    Logger.debug("*** Value: #{inspect val}")
    {:noreply, state}
  end

  def handle_info(data, state) do
    Logger.debug("*** INFO: #{inspect data}")
    {:noreply, state}
  end
end
