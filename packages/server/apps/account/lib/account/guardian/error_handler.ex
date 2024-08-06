defmodule Account.Guardian.ErrorHandler do
  @moduledoc """
  Callback handler from Guardian when there is a issue with the tokens
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Imports
  # ----------------------------------------------------------------------------
  import Plug.Conn

  # ----------------------------------------------------------------------------
  # Module Behaviours
  # ----------------------------------------------------------------------------
  @behaviour Guardian.Plug.ErrorHandler

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Callback for auth errors
  """
  @impl Guardian.Plug.ErrorHandler
  @spec auth_error(Plug.Conn.t(), {any(), any()}, any()) :: Plug.Conn.t()
  def auth_error(conn, {_type, reason}, _opts) do
    Logger.error("[#{__MODULE__}.auth_error/3] REASON: #{inspect(reason)}")

    conn
    |> clear_session()
    |> send_resp(403, "#{reason}")

    # |> Phoenix.Controller.redirect(to: "/auth/login")
  end
end
