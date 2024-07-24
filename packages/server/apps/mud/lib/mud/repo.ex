defmodule MUD.Repo do
  use Ecto.Repo,
    otp_app: :mud,
    adapter: Ecto.Adapters.Postgres

  def set_search_path(_conn, _path) do
    #{:ok, _result} = Postgrex.query(conn, "SET search_path=#{path}", [])
    :ok
  end
end
