defmodule DraftServer.Repo.Migrations.ChangeUserToSentinel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username,                    :string
      add :role,                        :string
      add :hashed_password,             :string
      add :hashed_confirmation_token,   :string
      add :confirmed_at,                :datetime
      add :hashed_password_reset_token, :string
      add :unconfirmed_email,           :string
    end
  end
end
