defmodule Faucet.Repo.Migrations.AddObanQueues do
  use Ecto.Migration

  def change do
    Oban.Pro.Migrations.DynamicQueues.change()
  end
end
