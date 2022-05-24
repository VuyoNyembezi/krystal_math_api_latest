defmodule KrystalMathApi.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :is_active, :bool
    end
    create unique_index(:teams,[:name])
  end
end
