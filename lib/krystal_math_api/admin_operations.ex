defmodule KrystalMathApi.AdminOperations do
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Accounts.{Role}
  alias KrystalMathApi.Operations.{Team, Environment, TaskStatus, UserStatus}

  alias KrystalMathApi.Projects.CategoriesAndImportance.{
    Priority,
    ProjectType,
    Status,
    ProjectCategoryType
  }

  ###### ACCOUNTS #####

  ############ Role  ##########
  @doc """
  select all roles
  """
  def list_all_roles do
    Role
    |> Repo.all()
  end

  @doc """
  selectone record roles
  """
  def get_user_role!(id) do
    Role
    |> Repo.get!(id)
  end

  @doc """
  update role record
  """
  def update_role(%Role{} = user_role, attrs) do
    user_role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  create role record
  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  delete Role Record
  """
  def delete_user_role(%Role{} = user_role) do
    Repo.delete(user_role)
  end

  @doc """
  keeps track of every change
  """
  def change_role(%Role{} = user_role, attrs \\ %{}) do
    Role.changeset(user_role, attrs)
  end

  ##### TASKS #####

  ##### ENVIROMENT #####
  @doc """
  gets all environments
  """
  def list_all_environments do
    Repo.all(Environment)
  end

  @doc """
  get envioroment by id
  """
  def get_environment!(id), do: Repo.get!(Environment, id)

  @doc """
  select environment by name
  """
  def get_environment_by_name(name) when is_binary(name) do
    case Repo.get_by(Environment, name: name) do
      nil ->
        {:error, :not_found}

      environment ->
        {:ok, environment}
    end
  end

  @doc """
  add new environment
  """

  def add_environment(attrs \\ %{}) do
    %Environment{}
    |> Environment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update environment details
  """
  def update_environment(%Environment{} = environment, attrs) do
    environment
    |> Environment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  delete Envroment Record
  """
  def delete_enviroment(%Environment{} = environment) do
    Repo.delete(environment)
  end

  @doc """
  keeps track of every change
  """
  def change_environment(%Environment{} = environment, attrs \\ %{}) do
    Environment.changeset(environment, attrs)
  end

  ##### TASK STATUS  #### 
  @doc """
  get task status by id
  """
  def get_task_status!(id), do: Repo.get!(TaskStatus, id)

  @doc """
  gets all task status
  """
  def list_all_task_status do
    Repo.all(TaskStatus)
  end

  @doc """
  select task status by name
  """
  def get_task_status_by_name(name) when is_binary(name) do
    case Repo.get_by(TaskStatus, name: name) do
      nil ->
        {:error, :not_found}

      task_status ->
        {:ok, task_status}
    end
  end

  @doc """
  add new task status
  """

  def add_task_status(attrs \\ %{}) do
    %TaskStatus{}
    |> TaskStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update task status details
  """
  def update_task_status(%TaskStatus{} = task_status, attrs) do
    task_status
    |> TaskStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  delete task status Record
  """
  def delete_task_status(%TaskStatus{} = task_status) do
    Repo.delete(task_status)
  end

  @doc """
  keeps track of every change
  """
  def change_task_status(%TaskStatus{} = task_status, attrs \\ %{}) do
    TaskStatus.changeset(task_status, attrs)
  end

  ###### TEAM  ####
  @doc """
  get team by id
  
  def get_team!(id), do: Repo.get!(Team, id)
  """
  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(:users)
  end

  @doc """
  gets all teams
  """
  def list_all_teams do
    Team
    |> Repo.all()
    |> Repo.preload(:team_lead)
  end

  @doc """
  gets all not active  teams
  """
  def list_not_active_teams do
    Repo.all(from t in Team, where: t.is_active == false)
    |> Repo.preload(:team_lead)
  end

  @doc """
  gets all active  teams
  """
  def list_active_teams do
    Repo.all(from t in Team, where: t.is_active == true)
    |> Repo.preload(:team_lead)
  end

  @doc """
  select team by name
  """
  def get_team_by_name(name) when is_binary(name) do
    case Repo.get_by(Team, name: name) do
      nil ->
        {:error, :not_found}

      team ->
        {:ok, team}
    end
  end

  @doc """
  add new team
  """

  def add_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update team details
  """

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deactivate team
  """
  def deactivate_team(%Team{} = team, attrs) do
    team
    |> Team.deactivate_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  activate team
  """
  def activate_team(%Team{} = team, attrs) do
    team
    |> Team.activate_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  delete team Record
  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  keeps track of every change
  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  ##### PROJECT ASSIGNMENTS ###########

  #### USER STATUS ######
  @doc """
  get all user status
  """
  def list_all_user_status do
    Repo.all(UserStatus)
  end

  @doc """
  get user Status by id
  """

  # def get_user_status!(id), do: Repo.get!(Task, id)

  def get_user_status!(id) do
    UserStatus
    |> Repo.get!(id)

    # |> Repo.preload([:team, :user, :task_status, :environment])
  end

  @doc """
  add new task
  """
  def add_user_status(attrs \\ %{}) do
    %UserStatus{}
    |> UserStatus.changeset(attrs)
    |> Repo.insert()
  end

  ### DELETE #####
  @doc """
  deletes the record of the user Status
  
  """
  def delete_user_status(%UserStatus{} = user_status) do
    Repo.delete(user_status)
  end

  @doc """
  update user status details
  """
  def update_user_status(%UserStatus{} = user_status, attrs) do
    user_status
    |> UserStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  keeps track of every change
  """
  def change_user_status(%UserStatus{} = user_status, attrs \\ %{}) do
    UserStatus.changeset(user_status, attrs)
  end

  ##### MAIN PROJECTS ################

  ###### Project STATUS   ######
  @doc """
  get status  by id
  """

  def get_project_status!(id) do
    Status
    |> Repo.get!(id)
  end

  @doc """
  get all records
  """
  def get_all_project_statuses do
    Repo.all(Status)
  end

  @doc """
  create status record
  """
  def add_project_status(attrs \\ %{}) do
    %Status{}
    |> Status.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update project type  record
  """

  def update_project_status_value(%Status{} = project_status, attrs) do
    project_status
    |> Status.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deletes the record of the project Status
  
  """
  def delete_project_status(%Status{} = project_status) do
    Repo.delete(project_status)
  end

  @doc """
  keeps track of every change
  """
  def change_project_status(%Status{} = project_status, attrs \\ %{}) do
    Status.changeset(project_status, attrs)
  end

  ####### PRIORITY ####
  @doc """
  get priority type by id
  """

  def get_priority!(id) do
    Priority
    |> Repo.get!(id)
  end

  @doc """
  get all priority type records
  """
  def get_all_priorities do
    Repo.all(Priority)
  end

  @doc """
  create priority record
  """
  def create_priority(attrs \\ %{}) do
    %Priority{}
    |> Priority.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update priority record
  """

  def update_priority(%Priority{} = priority_type, attrs) do
    priority_type
    |> Priority.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deletes the record of the project Status
  
  """
  def delete_priority_type(%Priority{} = priority_type) do
    Repo.delete(priority_type)
  end

  @doc """
  keeps track of every change
  """
  def change_priority_type(%Priority{} = priority_type, attrs \\ %{}) do
    Status.changeset(priority_type, attrs)
  end

  ## PROJECT TYPE  ######

  @doc """
  get project type  by id
  """

  def get_project_type!(id) do
    ProjectType
    |> Repo.get!(id)
  end

  @doc """
  get all records
  """
  def get_all_project_types do
    Repo.all(ProjectType)
  end

  @doc """
  create project Type  record
  """
  def create_project_type(attrs \\ %{}) do
    %ProjectType{}
    |> ProjectType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update project type  record
  """

  def update_project_type(%ProjectType{} = project_type, attrs) do
    project_type
    |> ProjectType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deletes the record of the project type
  
  """
  def delete_project_type(%ProjectType{} = project_type) do
    Repo.delete(project_type)
  end

  @doc """
  keeps track of every change
  """
  def change_project_type(%ProjectType{} = project_type, attrs \\ %{}) do
    ProjectType.changeset(project_type, attrs)
  end

  ## PROJECT CATEGORY TYPE CONTEXT FUNCTIONS  ######

  @doc """
  get project category type  by id
  """

  def get_project_category_type!(id) do
    ProjectCategoryType
    |> Repo.get!(id)
  end

  @doc """
  get all records
  """
  def get_all_project_category_types do
    Repo.all(ProjectCategoryType)
  end

  @doc """
  create project category Type  record
  """
  def create_project_category(attrs \\ %{}) do
    %ProjectCategoryType{}
    |> ProjectCategoryType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update project category type  record
  """

  def update_project_category_type(%ProjectCategoryType{} = project_category_type, attrs) do
    project_category_type
    |> ProjectCategoryType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deletes the record of the project category type
  
  """
  def delete_project_category_type(%ProjectCategoryType{} = project_category_type) do
    Repo.delete(project_category_type)
  end

  @doc """
  keeps track of every change
  """
  def change_project_category_type(%ProjectCategoryType{} = project_category_type, attrs \\ %{}) do
    ProjectCategoryType.changeset(project_category_type, attrs)
  end
end
