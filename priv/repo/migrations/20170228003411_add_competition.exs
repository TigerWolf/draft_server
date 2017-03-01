defmodule DraftServer.Repo.Migrations.AddCompetition do
  use Ecto.Migration

  def change do
    create table(:competitions) do
      add :name, :string
      add :round, :integer, default: 1
      add :code, :string

      timestamps
    end
  end
end
