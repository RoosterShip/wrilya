defmodule Faucet.Repo.Migrations.AddObanCrons do
  use Ecto.Migration

  def up do
    Oban.Pro.Migrations.DynamicCron.up();
  end

  def down do
    Oban.Pro.Migrations.DynamicCron.down();
  end
end
