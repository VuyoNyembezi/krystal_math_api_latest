defmodule KrystalMathApi.Projects.CategoriesAndImportance.ProjectType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_types" do
    field :name, :string
  end

  def changeset(project_type, attrs) do
    project_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
