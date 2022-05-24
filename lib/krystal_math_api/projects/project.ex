defmodule KrystalMathApi.Projects.Project do
    use Ecto.Schema
    import Ecto.Changeset
    alias KrystalMathApi.Projects.CategoriesAndImportance.{ProjectType, Status, Priority,ProjectCategoryType}
    alias KrystalMathApi.Operations.{Team}
    alias KrystalMathApi.Accounts.User
  
    schema "projects" do
      belongs_to :project_type, ProjectType, foreign_key: :project_type_id
      belongs_to :project_category_type, ProjectCategoryType, foreign_key: :project_category_type_id
      field :name, :string
      field :last_status_change, :naive_datetime
      field :business_request_document_status, :boolean, default: false
      field :business_request_document_link, :string, default: "none"
      belongs_to :team, Team, foreign_key: :team_id
      belongs_to :user, User, foreign_key: :user_id
      belongs_to :project_status, Status, foreign_key: :project_status_id
      belongs_to :priority_type, Priority, foreign_key: :priority_type_id
      timestamps()
    end
  
  def changeset(project, attrs) do
    project
      |> cast(attrs, [:project_type_id, :name, :business_request_document_status,:last_status_change, :business_request_document_link, :team_id,:user_id, :project_status_id, :priority_type_id, :project_category_type_id])
      |> validate_required([:project_type_id,:name, :business_request_document_status, :team_id, :user_id, :project_status_id, :priority_type_id,  :project_category_type_id])
      |> unique_constraint(:name)
  end
  end
  