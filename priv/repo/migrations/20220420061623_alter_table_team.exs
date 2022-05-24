defmodule KrystalMathApi.Repo.Migrations.AlterTableTeam do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :team_lead_id, references(:users), null: true
    end
  end
end
