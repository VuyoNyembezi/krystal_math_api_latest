defmodule KrystalMathApi.Repo.Migrations.CreateProjectType do
  use Ecto.Migration

  def change do
    create table(:project_types) do
      add :name, :string
    end
    create unique_index(:project_types,[:name])
  end
end
