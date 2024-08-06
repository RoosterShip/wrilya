defmodule Faucet.Repo.Migrations.AddObanProducers do
  use Ecto.Migration
  def change do
    Oban.Pro.Migrations.Producers.change()
  end
end
