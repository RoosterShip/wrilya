defmodule Faucet.Repo.Migrations.AddKeys do
  use Ecto.Migration

  def change do
    create table(:keys, primary_key: false) do
      add(:id, :binary_id, primary_key: true, autogenerate: true)
      add(:source_id, references(:sources, type: :binary_id))
      add(:type, :integer, null: false)
      add(:key, :binary)
      add(:active, :boolean, null: false)
      timestamps()
    end

    create index(:keys, [:source_id])
    create index(:keys, [:type])
    create index(:keys, [:id, :active], unique: true)
  end
end
