defmodule KrystalMathApi.Projects.ProjectAssignment do
    use Ecto.Schema
    import Ecto.Changeset
    alias KrystalMathApi.Accounts.User
    alias KrystalMathApi.Operations.{Team, UserStatus}
    alias KrystalMathApi.Projects.Project
    alias KrystalMathApi.Projects.CategoriesAndImportance.{ProjectType,ProjectCategoryType}
   
    schema "projects_assignments" do
      belongs_to :user_status, UserStatus, foreign_key: :user_status_id
      belongs_to :user, User, foreign_key: :user_id
      belongs_to :team, Team, foreign_key: :team_id
      belongs_to :project_type, ProjectType, foreign_key: :project_type_id
      belongs_to :project_category_type, ProjectCategoryType, foreign_key: :project_category_type_id
      belongs_to :project, Project, foreign_key: :project_id
      field :kickoff_date, :naive_datetime
      field :due_date, :naive_datetime
      field :active, :boolean, default: true
      timestamps()
    end
  
    def changeset(projects_assignment, attrs) do
      projects_assignment
      |> cast(attrs, [:project_type_id, :team_id,:user_id, :user_status_id,:project_id, :due_date, :kickoff_date, :active, :project_category_type_id ])
      |> validate_required([:project_type_id, :team_id, :user_status_id, :project_id, :due_date, :project_category_type_id ])
    end
  
    def activation_changeset(projects_assignment, attrs) do
      projects_assignment
      |> cast(attrs, [
        :project_type_id,
        :team_id,
        :user_id,
        :user_status_id,
        :project_id,
        :due_date,
        :kickoff_date,
        :project_category_type_id,
        :active
      ])
      |> put_change(:active, true)
    end
    def de_activation_changeset(projects_assignment, attrs) do
      projects_assignment
      |> cast(attrs, [
        :project_type_id,
        :team_id,
        :user_id,
        :user_status_id,
        :project_id,
        :due_date,
        :kickoff_date,
        :project_category_type_id,
        :active
      ])
      |> put_change(:active, false)
    end
  end
  