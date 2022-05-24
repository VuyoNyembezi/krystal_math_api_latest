defmodule KrystalMathApi.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :name, :string
    end
    create unique_index(:user_roles, [:name])
  end
end
