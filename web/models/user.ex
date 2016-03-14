defmodule DraftServer.User do
  use Ecto.Model

  schema "users" do
    field  :username,                    :string
    field  :email,                       :string
    field  :role,                        :string
    field  :hashed_password,             :string
    field  :hashed_confirmation_token,   :string
    field  :confirmed_at,                Ecto.DateTime
    field  :hashed_password_reset_token, :string
    field  :unconfirmed_email,           :string
    field  :turn,                        :integer

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def permissions(role) do
  end
end
