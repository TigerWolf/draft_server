defmodule DraftServer.Repo.Migrations.AddOrderToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :turn, :integer
    end
  end
end
