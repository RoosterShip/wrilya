defmodule MUD.Data.GameNotification do
  use Ecto.Schema

  @schema_prefix "0x8d8b6b8414e1e3dcfd4168561b9be6bd3bf6ec4b"
  @primary_key {:__key_bytes, :binary, autogenerate: false}
  schema "game__notification_tabl" do
    field :operation, :integer
    field :nid, :binary
    field :data, :binary
    field :__last_updated_block_number, :decimal
  end
end
