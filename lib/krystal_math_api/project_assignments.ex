defmodule KrystalMathApi.ProjectAssignments do
    import Ecto.Query, warn: false
     alias KrystalMathApi.Repo
     alias KrystalMathApi.Projects.ProjectAssignment
     alias KrystalMathApi.Projects.CategoriesAndImportance.ProjectType
 
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

    def get_project_types(project_type)  do
      query = from(pt in ProjectType,select: pt.id, where: pt.name == ^project_type)
      Repo.one(query)
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
  # Map Fucntion 
def team_project_assignments(team_id) do
project_types =%{
  bet_project: get_project_types("BET Projects"),
  country_project: get_project_types("Country"),
  customer_journey: get_project_types("Customer Journey"),
  integrations: get_project_types("Integrations"),
  payment_methods: get_project_types("Payment Methods /Gateways"),
  digital_marketing: get_project_types("Digital Marketing"),
  bet_project_partners: get_project_types("BETSoftware Partners"),
}

  team_assignment = %{
    bet_projects: get_project_assigned_type(team_id , project_types.bet_project),
    country_projects: get_project_assigned_type(team_id , project_types.country_project),
    customer_journey_projects: get_project_assigned_type(team_id , project_types.customer_journey),
    integrations_projects: get_project_assigned_type(team_id , project_types.integrations),
    payment_method_projects: get_project_assigned_type(team_id , project_types.payment_methods),
    digital_marketing_projects: get_project_assigned_type(team_id , project_types.digital_marketing),
    bet_project_partners_projects: get_project_assigned_type(team_id , project_types.bet_project_partners)
  }

  team_assignment

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
# Map Fucntion 
def dev_project_assignments(team_id, user_id) do
  project_types =%{
    bet_project: get_project_types("BET Projects"),
    country_project: get_project_types("Country"),
    customer_journey: get_project_types("Customer Journey"),
    integrations: get_project_types("Integrations"),
    payment_methods: get_project_types("Payment Methods /Gateways"),
    digital_marketing: get_project_types("Digital Marketing"),
    bet_project_partners: get_project_types("BETSoftware Partners"),
  }
  

        [dev_assignment] = [%{
          bet_projects: project_type_dev_assigned(team_id , project_types.bet_project, user_id),
          country_projects: project_type_dev_assigned(team_id , project_types.country_project, user_id),
          customer_journey_projects: project_type_dev_assigned(team_id , project_types.customer_journey, user_id),
          integrations_projects: project_type_dev_assigned(team_id , project_types.integrations, user_id),
          payment_method_projects: project_type_dev_assigned(team_id , project_types.payment_methods, user_id),
          digital_marketing_projects: project_type_dev_assigned(team_id , project_types.digital_marketing, user_id),
          bet_project_partners_projects: project_type_dev_assigned(team_id , project_types.bet_project_partners, user_id)
        }]

        dev_assignment
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

def user_assignment_all(team_id, category_id ,user_id) do
  
  assignments = from( p in ProjectAssignment,select: count(p.id), where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id )
 Repo.one(assignments)

end
def user_completed_assignment(team_id, category_id, user_id) do
  
  completed = 6 
  completed_assignments = from( p in ProjectAssignment,select: count(p.id), where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id and p.user_status_id == ^completed)
  Repo.one(completed_assignments)
 
end
def user_pending_assignment(team_id, category_id ,user_id) do
  completed = 6 
pending_assignments = from( p in ProjectAssignment,select: count(p.id), where: p.project_category_type_id == ^category_id and p.team_id == ^team_id and p.user_id == ^user_id and p.user_status_id != ^completed)
  Repo.one(pending_assignments)
end


def user_assignment(team_id, category_id ,user_id) do
  user_assignment_counters = %{
    all_assignments: user_assignment_all(team_id, category_id, user_id),
  completed: user_completed_assignment(team_id, category_id, user_id),
  pending: user_pending_assignment(team_id, category_id, user_id)}
  user_assignment_counters
end









end