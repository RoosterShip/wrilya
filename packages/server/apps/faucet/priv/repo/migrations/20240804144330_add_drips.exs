defmodule Faucet.Repo.Migrations.AddDrips do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:drips, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :source_id, references(:sources, type: :binary_id)
      add :address, :binary, null: false
      add :amount, :bigint, null: false
      timestamps()
    end

    create index(:drips, [:address])
    create index(:drips, [:source_id])
  end
end
