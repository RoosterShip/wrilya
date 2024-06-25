defmodule Wrilya.Repo.Migrations.AddObanQueues do
  use Ecto.Migration

  defdelegate change, to: Oban.Pro.Migrations.DynamicQueues
end
