defmodule Wrilya.Repo do
  use Ecto.Repo,
    otp_app: :wrilya,
    adapter: Ecto.Adapters.Postgres
end
