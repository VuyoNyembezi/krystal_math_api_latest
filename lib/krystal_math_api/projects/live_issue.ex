defmodule KrystalMathApi.Projects.LiveIssue do
    use Ecto.Schema
    import Ecto.Changeset
    alias KrystalMathApi.Projects.CategoriesAndImportance.{ Status, Priority}
    alias KrystalMathApi.Operations.{Team}
    alias KrystalMathApi.Accounts.User
    import Ecto.Query, warn: false
  
    schema "live_issues" do
      field :name, :string
      field :business_request_document_status, :boolean, default: false
      field :business_request_document_link, :string, default: "none"
      belongs_to :team, Team, foreign_key: :team_id
      belongs_to :user, User, foreign_key: :pm_id
      belongs_to :project_status, Status, foreign_key: :project_status_id
      belongs_to :priority_type, Priority, foreign_key: :priority_type_id
      field :last_status_change, :naive_datetime
      field :assigned_date, :naive_datetime
      field :is_active, :boolean, default: true
      timestamps()
    end
  
    def changeset(live_issue, attrs) do
      live_issue
        |> cast(attrs, [:name, :business_request_document_status, :business_request_document_link, :team_id,:pm_id, :project_status_id, :priority_type_id, :last_status_change, :assigned_date, :is_active])
        |> validate_required([:name, :business_request_document_status, :team_id, :pm_id, :project_status_id, :priority_type_id, :is_active])
        |> unique_constraint(:name)  
    end

    def status_changeset(live_issue, attrs) do
      live_issue
        |> cast(attrs, [:project_status_id, :last_status_change, :is_active])
        |> validate_required([:project_status_id])
    end
  
  end
  