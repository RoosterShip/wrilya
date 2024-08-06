defmodule WrilyaWeb.Session.VoidsmanController do
  use WrilyaWeb, :controller
  require Logger

  plug Request.Validator.Plug,
    premint: WrilyaWeb.Requests.Session.Voidsman.Premint

  def manifest(conn, _params) do
    send_resp(conn, 200, Jason.encode!([]))
  end


  def premint(conn, params) do
    # 1.  Create a new offchain entity store with
    #     params data.
    #     - Should generate a UUID
    #     - Should write the offchain data to a map meta field
    #     - Use Postgres table to enable replication
    #     - Setup Wallet Key
    #     - Use the wallet key to sign a payload
    # 2. Client will then send that to the blockchain.

    Logger.debug("#{inspect params, pretty: true}");
    send_resp(conn, 200, Jason.encode!(%{rsp: :ok}))
  end

  @doc """
  Some Webrowsers try and do an options check first to ensure CORS security.
  This callback is to ensure that the premint is executed correctly.
  """
  def premintOptions(conn, _params), do: send_resp(conn, 200, :ok)
end
