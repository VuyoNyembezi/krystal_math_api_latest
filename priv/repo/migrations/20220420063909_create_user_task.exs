defmodule KrystalMathApi.Repo.Migrations.CreateUserTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :team_id, references(:teams)
      add :user_id, references(:users)
      add :environment_id, references(:environments)
      add :due_date, :naive_datetime
      add :kickoff_date, :naive_datetime
      add :task_comment, :string
      add :active, :bool
      add :task_status_id, references(:task_statuses)
      timestamps()
    end

    create unique_index(:tasks,[:name])
  end
end
