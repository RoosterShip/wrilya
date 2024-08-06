defmodule Faucet.Types do
  @moduledoc """
  Constants and types used by the application.
  """

  # ----------------------------------------------------------------------------
  # Module Using Definition
  # ----------------------------------------------------------------------------
  @spec __using__(any()) :: {:__block__, [], [{:@, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      # -----------------------------------------------------------------------
      #  Ecto max integer size
      # -----------------------------------------------------------------------
      @max_ecto_integer 9_223_372_036_854_775_807

      # -----------------------------------------------------------------------
      #  Source Types Enumerations
      # -----------------------------------------------------------------------
      @source_types [faucet: 0, reservoir: 1]
      @type source_types :: :faucet | :reservoir
    end
  end
end
