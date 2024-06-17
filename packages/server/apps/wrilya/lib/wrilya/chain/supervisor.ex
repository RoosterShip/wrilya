defmodule Wrilya.Chain.Supervisor do
  @moduledoc """
  A basic supervisor for the Discord polling process (consumer).

  Note:  Current the Discord Consumer is NOT horizontally scalable.
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Supervisor
  require Logger
  @default_chain_notify_consumers 5

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc false
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_args) do
    count = Application.get_env(
      :wrilya,
      :chain_notify_consumers,
      @default_chain_notify_consumers)

    Supervisor.start_link(__MODULE__, count, name: __MODULE__)
  end

  @doc false
  @impl true
  @spec init(any()) ::
          {:ok,
           {%{
              auto_shutdown: :all_significant | :any_significant | :never,
              intensity: non_neg_integer(),
              period: pos_integer(),
              strategy: :one_for_all | :one_for_one | :rest_for_one
            }, [{any(), any(), any(), any(), any(), any()} | map()]}}
  def init(count) do
    children = for n <- 0 .. count, do: Supervisor.child_spec({Wrilya.Chain.Consumer, n}, id: String.to_atom("wdc_#{n}"))
    Supervisor.init(children, strategy: :one_for_one)
  end
end
