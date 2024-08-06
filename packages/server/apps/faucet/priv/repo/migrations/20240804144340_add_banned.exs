defmodule Faucet.Repo.Migrations.AddBanned do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:banned, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :source_id, references(:sources, type: :binary_id)
      add :address, :binary, null: false
      timestamps()
    end

    create index(:banned, [:address], unique: true)
    create index(:banned, [:source_id])
  end
end
