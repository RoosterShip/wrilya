defmodule MUD.Data do

  import Ecto.Query

  def get_entity_owner() do
    query = from eo in MUD.Data.GameEntityOwner, select: eo.value
    MUD.Repo.all(query, prefix: "0x8d8b6b8414e1e3dcfd4168561b9be6bd3bf6ec4b")
  end

  def get_notification_owner() do
    query = from gn in MUD.Data.GameNotification, select: gn
    MUD.Repo.all(query)
  end
end
