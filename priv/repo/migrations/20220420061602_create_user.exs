defmodule KrystalMathApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :employee_code, :string
      add :name, :string
      add :last_name, :string
      add :password, :string
      add :team_id, references(:teams)
      add :is_active, :bool
      add :password_reset, :string
      add :user_role_id, references(:user_roles)
      add :is_admin, :boolean, default: false
      add :email, :string
      timestamps()
    end

    create unique_index(:users,[:employee_code])
    create unique_index(:users,[:email])
  end
end
