defmodule Wrilya.Chain.Cache do
  require Logger

  use Wrilya.Chain.Constants

  @entity_voidsman_select """
  SELECT
    e.value,
    vp.home,
    vp.name,
    vp.portrait
  FROM
    game__entity_type_table AS e
    JOIN game__voidsman_persona_t AS vp
      ON vp.__key_bytes = '\\x0000000000000000000000000000000000000000000000000000000000000002'
  """

  def balance() do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres", search_path: ["0x8d8b6b8414e1e3dcfd4168561b9be6bd3bf6ec4b"])

    out = Postgrex.query!(pid, @entity_voidsman_select, [])
    Logger.debug("OUT = #{inspect out, pretty: true, structs: false}")
  end

  def voidsman(entity_id) do
    eid = Base.encode16(entity_id)
    query = """
    SELECT
      vp.home,
      vp.name,
      vp.portrait
    FROM
      game__voidsman_persona_t AS vp
    WHERE
      vp.__key_bytes ='\\x#{eid}'
    """
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres", search_path: ["0x8d8b6b8414e1e3dcfd4168561b9be6bd3bf6ec4b"])
    %{rows: [[home, name, portrait]]} = Postgrex.query!(pid, query, [])

    # Return
    {:ok, %{
      name: name,
      home: Map.get(@home_enum_names, home, "Icoir"),
      portrait: portrait
    }}
  rescue
    exception -> {:error, exception}
  end
end
