defmodule KrystalMathApi.Repo.Migrations.CreateProjectCategoryType do
  use Ecto.Migration

  def change do
    create table(:project_category_types) do
      add :name, :string
    end

    create unique_index(:project_category_types, [:name])
  end
end
