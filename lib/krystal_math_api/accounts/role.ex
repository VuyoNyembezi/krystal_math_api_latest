defmodule KrystalMathApi.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias KrystalMathApi.Accounts.Role

    schema "user_roles" do
    
      field :name, :string
    end
    def changeset(%Role{} = user_role, attrs) do
      user_role
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> unique_constraint(:name)

    end
end
