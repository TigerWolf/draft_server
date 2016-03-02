defmodule DraftServer.Repo.Migrations.CreateDraft do
  use Ecto.Migration

  def change do
    create table(:drafts) do
      add :player_id, :string
      add :position, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:drafts, [:user_id])
    create unique_index(:drafts, [:player_id])

  end
end
