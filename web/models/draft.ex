defmodule DraftServer.Draft do
  use DraftServer.Web, :model

  schema "drafts" do
    field :player_id, :string
    field :position, :string
    belongs_to :user, DraftServer.User

    timestamps
  end

  @required_fields ~w(player_id position user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:player_id)
  end
end
