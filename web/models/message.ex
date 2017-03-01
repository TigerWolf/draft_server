defmodule DraftServer.Message do
  use DraftServer.Web, :model

  schema "messages" do
    field :user, :string
    field :text, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user, :text])
    |> validate_required([:user, :text])
  end
end
