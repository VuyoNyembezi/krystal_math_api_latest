defmodule KrystalMathApi.Projects.CategoriesAndImportance.Priority do
  use Ecto.Schema
  import Ecto.Changeset

  schema "priority_types" do
    field :name, :string
    field :level, :string
  end

  def changeset(priority_type, attrs) do
    priority_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
