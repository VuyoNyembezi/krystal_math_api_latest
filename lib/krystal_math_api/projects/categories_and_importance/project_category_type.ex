defmodule KrystalMathApi.Projects.CategoriesAndImportance.ProjectCategoryType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_category_types" do
    field :name, :string
  end

  def changeset(project_category_type, attrs) do
    project_category_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
