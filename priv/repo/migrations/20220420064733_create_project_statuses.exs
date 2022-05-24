defmodule KrystalMathApi.Repo.Migrations.CreateProjectStatuses do
  use Ecto.Migration

  def change do
    create table(:project_statuses) do
      add :name, :string
      add :effect, :integer,null: true
      add :level, :string, null: true
    end
    create unique_index(:project_statuses,[:name])
  end
end
