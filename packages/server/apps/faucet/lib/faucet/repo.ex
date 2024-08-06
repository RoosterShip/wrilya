defmodule Faucet.Repo do
  @moduledoc false

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use Ecto.Repo,
    otp_app: :faucet,
    adapter: Ecto.Adapters.Postgres
end
