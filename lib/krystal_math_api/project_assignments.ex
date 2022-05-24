defmodule KrystalMathApi.ProjectAssignments do
    import Ecto.Query, warn: false
     alias KrystalMathApi.Repo
     alias KrystalMathApi.Projects.ProjectAssignment
     
 
     def active_users do
      query = from(u in "users",
      join: t in "teams",
      on: t.id == u.team_id,
      select:
      %{
        id: u.id, email: u.email,  password: u.password, employee_code: u.employee_code, name: u.name, last_name: u.last_name, team: t.name,team_id: u.team_id,
        password_reset: u.password_reset, is_active: u.is_active, is_admin: u.is_admin} ,
      where: u.is_active == true)
      Repo.all(query)
    end


####### SEARCH METHODS #################

  # search for projects filtered by team id 
    def team_project_assignment_search(team_id,project_type, search_term) do
      search_name = "%#{search_term}%"
        Repo.all(from(pa in ProjectAssignment,
        join: p in "projects",
        on: p.id == pa.team_id,
        where: like(p.name, ^search_name) and pa.team_id == ^team_id and pa.project_type_id == ^project_type))
        |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
    end

  # search for projects assignment filtered by team id and user id
    def user_project_assignment_search(team_id,project_type, user_id, search_term) do
      search_name = "%#{search_term}%"
        Repo.all(from(pa in ProjectAssignment,
        join: p in "projects",
        on: p.id == pa.team_id,
        where: like(p.name, ^search_name) and pa.team_id == ^team_id and pa.user_id == ^user_id and pa.project_type_id == ^project_type))
        |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
    end


  @doc """
  get record of bet project assignment  by id
  """

  def get_assignment_project!(id) do
    ProjectAssignment
    |> Repo.get!(id)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end

  # list all  projects asignments
  def list_assigned_projects do
    ProjectAssignment
    |> Repo.all()
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end

    @doc """
  gets all projects assignements by project type (Live Issues , Operational, Strategic)
  """
  def all_projects_assignments_project_type(project_type) do
    query = from(a in ProjectAssignment, where: a.project_type_id == ^project_type)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end
  @doc """
  gets all projects assignements to member
  """
  def all_projects_assignment_to_member(user_id) do
    query = from(a in ProjectAssignment, where: a.user_id == ^user_id)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end
   @doc """
  gets all projects assignements to a Team
  """
  def all_projects_assignment_to_team(team_id) do
    query = from(a in ProjectAssignment, where: a.team_id == ^team_id)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end

   @doc """
  gets all assigned assigned members on the project
  """
  def get_project_assigned_details(team_id, project_id) do
    query = from(a in ProjectAssignment, where: a.team_id == ^team_id and a.project_id == ^project_id and a.user_id != 2)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end
     @doc """
  gets all assigned assigned record by project, type
  """
  def get_project_assigned_type(team_id, project_type) do
    query = from(a in ProjectAssignment, where: a.team_id == ^team_id and a.project_type_id == ^project_type and a.user_id != 2)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end

  ### DEV/User  Assigned ###

  @doc """ 
  get projects assigned to the user
  """
  def get_project_dev_assigned(team_id, user_id) do
    query = from(a in ProjectAssignment, where: a.team_id == ^team_id  and a.user_id == ^user_id)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end

   @doc """ 
  get projects assigned to the user by project Type 
  """
  def project_type_dev_assigned(team_id , project_type, user_id) do
    query = from(a in ProjectAssignment, where: a.team_id == ^team_id  and a.project_type_id == ^project_type and a.user_id == ^user_id)
    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team ])
  end























  # Add Assignment Record bet projects
  def create_project_assignment(attrs \\%{}) do
    %ProjectAssignment{}
    |> ProjectAssignment.changeset(attrs)
    |> Repo.insert()
  end

    @doc """
  update bet project Assignement  details
  """
  def update_project_assign(%ProjectAssignment{} = projects_assignment, attrs) do
    projects_assignment
    |> ProjectAssignment.changeset(attrs)
    |> Repo.update()
  end

   @doc """
  deletes the record of the Assignment
  """

  def delete_assign_member(%ProjectAssignment{} = projects_assignment) do
      Repo.delete(projects_assignment)
  end
     



######  COUNTERS ##############

def user_assignment(team_id, category_id ,user_id) do
  
  assignments = from( p in ProjectAssignment,select: %{projects_count: count(p.id)}, where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id )
 Repo.all(assignments)

end
def user_completed_assignment(team_id, category_id, user_id) do
  
  completed = 6 
  completed_assignments = from( p in ProjectAssignment,select: %{completed_projects: count(p.id)}, where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id and p.user_status_id == ^completed)
  Repo.all(completed_assignments)
 
end
def user_pending_assignment(team_id, category_id ,user_id) do
  completed = 6 
pending_assignments = from( p in ProjectAssignment,select: %{pending_projects: count(p.id)}, where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id and p.user_status_id != ^completed)
  Repo.all(pending_assignments)
end










end