defmodule DraftServer.Draft do
  use DraftServer.Web, :model

  schema "drafts" do
    field :player_id, :string
    field :position, :string
    belongs_to :user, DraftServer.User
    belongs_to :competition, DraftServer.Competition

    timestamps
  end

  @required_fields ~w(player_id position user_id competition_id)
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
    |> foreign_key_constraint(:competition_id)
    # |> foreign_key_constraint(:drafts_competition_id)
  end
end
