defmodule KrystalMathApi.Operations.UserStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_statuses" do
    field :name, :string
  end

  def changeset(user_status, attrs) do
    user_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
