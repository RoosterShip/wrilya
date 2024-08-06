defmodule Account.Guardian.Pipeline do
  @moduledoc """
  Module Pipeline that uses plug to setup what to do with a session token
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Guardian.Plug.Pipeline,
    otp_app: :account,
    error_handler: Account.Guardian.ErrorHandler,
    module: Account.Guardian

  # ----------------------------------------------------------------------------
  # Module plug steps
  # ----------------------------------------------------------------------------
  # If there is a session token, restrict it to an access token and validate it
  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  # If there is an authorization header, restrict it to an access token and validate it
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  # Load the user if either of the verifications worked
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
