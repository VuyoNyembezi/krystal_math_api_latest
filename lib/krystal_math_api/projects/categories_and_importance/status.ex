defmodule KrystalMathApi.Projects.CategoriesAndImportance.Status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_statuses" do
    field :name, :string
    field :effect, :integer
    field :level, :string
  end

  def changeset(project_status, attrs) do
    project_status
    |> cast(attrs, [:name, :effect, :level])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
