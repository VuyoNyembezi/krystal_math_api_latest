defmodule KrystalMathApi.Repo.Migrations.CreateTaskStatus do
  use Ecto.Migration

  def change do
    create table(:task_statuses) do
      add :name, :string
      add :level, :string, null: true
    end
    create unique_index(:task_statuses,[:name])
  end
end
