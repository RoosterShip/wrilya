defmodule WrilyaWeb.StatusController do
  use WrilyaWeb, :controller

  def healthy(conn, _params) do
    send_resp(conn, 200, "OK")
  end

  def ready(conn, _params) do
    send_resp(conn, 200, "OK")
  end
end
