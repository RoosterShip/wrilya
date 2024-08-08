defmodule WrilyaWeb.SessionController do
  use WrilyaWeb, :controller
  require Logger

  def initialize(conn, %{"address" => address}) do
    case get_session(conn, "current_user") do
      nil ->
        send_resp(conn, 404, "FAILED")

      session ->
        _ = Wrilya.faucet_drip(address)

        rsp =
          session
          |> Map.drop([:__struct__, :updated_at, :inserted_at, :__meta__])
          |> Jason.encode!()

        send_resp(conn, 200, rsp)
    end
  end
end
