defmodule Wrilya.Repo.Migrations.AddMetaTable do
  use Ecto.Migration

  def change do

    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:meta, primary_key: false) do
       add :id, :binary_id, primary_key: true, autogenerate: true
       add :entity_id, :binary
       add :meta, :map
       timestamps()
    end

    create index(:meta, [:entity_id,], unique: true)
  end
end
