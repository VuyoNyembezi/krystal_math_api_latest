defmodule KrystalMathApi.Repo.Migrations.CreateLiveIssue do
  use Ecto.Migration

  def change do
    create table(:live_issues) do
      add :name, :string
      add :business_request_document_status, :boolean
      add :business_request_document_link, :string
      add :project_status_id, references(:project_statuses)
      add :pm_id, references(:users)
      add :team_id, references(:teams)
      add :priority_type_id, references(:priority_types)
      add :last_status_change, :naive_datetime
      add :assigned_date, :naive_datetime
      add :is_active, :bool
      timestamps()
    end
    create unique_index(:live_issues,[:name])
  end
end
