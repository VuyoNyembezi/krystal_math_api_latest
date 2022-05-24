defmodule KrystalMathApi.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :business_request_document_status, :boolean
      add :business_request_document_link, :string
      add :last_status_change, :naive_datetime
      add :project_status_id, references(:project_statuses)
      add :user_id, references(:users)
      add :team_id, references(:teams)
      add :project_type_id, references(:project_types)
      add :priority_type_id, references(:priority_types)
      add :project_category_type_id, references(:project_category_types)
      
      timestamps()
    end
    create unique_index(:projects,[:name])
  end
end
