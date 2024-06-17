defmodule Wrilya.Discord.Supervisor do
  @moduledoc """
  A basic supervisor for the Discord polling process (consumer).

  Note:  Current the Discord Consumer is NOT horizontally scalable.
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Supervisor

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc false
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
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
  def init(_init_arg) do
    children = [Wrilya.Discord.Consumer]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
