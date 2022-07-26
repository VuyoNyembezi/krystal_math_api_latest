defmodule KrystalMathApi.Repo.Migrations.CreateUserStatus do
  use Ecto.Migration

  def change do
    create table(:user_statuses) do
      add :name, :string
    end

    create unique_index(:user_statuses, [:name])
  end
end
