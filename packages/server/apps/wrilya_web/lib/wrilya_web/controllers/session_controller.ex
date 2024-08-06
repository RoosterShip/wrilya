defmodule WrilyaWeb.SessionController do
  use WrilyaWeb, :controller
  require Logger

  def info(conn, _params) do
    case get_session(conn, "current_user") do
      nil ->
        send_resp(conn, 404, "FAILED")

      session ->
        rsp =
          session
          |> Map.drop([:__struct__, :updated_at, :inserted_at, :__meta__])
          |> Jason.encode!()

        send_resp(conn, 200, rsp)
    end
  end
end
