defmodule Account.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, autogenerate: true
      add :type, :integer, null: false
      add :auth_id, :binary, null: false
      add :auth_type, :integer, null: false
      add :email, :binary, null: false
      add :avatar, :string, size: 128
      add :active, :boolean, default: true
      add :meta, :map
      timestamps()
    end

    # Unique email address constraint, via DB index
    # create index(:users, [:email, :type], unique: true)
    # create index(:users, [:auth_id, :type, :auth_type], unique: true)
  end
end
