defmodule DraftServer.Competition do
  use DraftServer.Web, :model

  schema "competitions" do
    field :name, :string
    field :round, :integer
    field :code, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :round, :code])
    |> validate_required([:name, :round, :code])
  end
end
