defmodule Wrilya.Repo.Migrations.UpgradeObanPro do
  use Ecto.Migration

  def up, do: Oban.Pro.Migration.up(version: "1.5.0")
  def down, do: Oban.Pro.Migration.down()
end
