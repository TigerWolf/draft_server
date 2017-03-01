defmodule DraftServer.Repo.Migrations.AddCompetitionToDraft do
  use Ecto.Migration

  def change do
    alter table(:drafts) do
      add :competition_id, references(:competitions, on_delete: :nothing)
    end
  end
end
