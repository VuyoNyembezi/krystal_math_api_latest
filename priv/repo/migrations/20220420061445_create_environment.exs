defmodule KrystalMathApi.Repo.Migrations.CreateEnvironment do
  use Ecto.Migration

  def change do
    create table(:environments) do
      add :name, :string
    end

    create unique_index(:environments, [:name])
  end
end
