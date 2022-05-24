defmodule KrystalMathApi.Repo.Migrations.CreateProjectPriority do
  use Ecto.Migration

  def change do
    create table(:priority_types) do
      add :name, :string
      add :level, :string, null: true
     end
     create unique_index(:priority_types,[:name])
  end
end
