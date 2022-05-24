defmodule KrystalMathApi.Repo.Migrations.CreateProjectAssignments do
  use Ecto.Migration

  def change do
    create table(:projects_assignments) do
      add :user_status_id, references(:user_statuses)
      add :user_id, references(:users)
      add :team_id, references(:teams)
      add :project_category_type_id, references(:project_category_types)
      add :project_type_id, references(:project_types)
      add :project_id, references(:projects)
      add :kickoff_date, :naive_datetime
      add :due_date, :naive_datetime
      add :active, :bool
      timestamps()
    end
  end
end
