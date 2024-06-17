defmodule Wrilya.Repo.Migrations.AddObanCrons do
  use Ecto.Migration

  defdelegate up, to: Oban.Pro.Migrations.DynamicCron
  defdelegate down, to: Oban.Pro.Migrations.DynamicCron
end
