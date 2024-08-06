defmodule Faucet.Repo.Migrations.AddSource do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false) do
      add(:id, :binary_id, primary_key: true, autogenerate: true)
      add(:active, :boolean, default: true, null: false)
      add(:type, :integer, null: false)
      add(:window_size, :integer, null: false)
      add(:drip_amount, :bigint, null: false)
      add(:drips_per_window, :integer, null: false)
      add(:receiver_max_balance, :bigint, null: false)
      add(:receiver_drips_per_window, :bigint, null: false)
      add(:reservoir_id, references(:sources, type: :binary_id))
      timestamps()
    end

    create index(:sources, [:reservoir_id])
    create index(:sources, [:type])
    create index(:sources, [:id, :active], unique: true)
  end
end
