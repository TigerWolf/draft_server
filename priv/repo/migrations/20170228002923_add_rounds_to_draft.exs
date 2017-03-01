defmodule DraftServer.Repo.Migrations.AddRoundsToDraft do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      add :round, :integer
    end
  end
end
