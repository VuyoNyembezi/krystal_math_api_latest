defmodule KrystalMathApi.Projects do
    import Ecto.Query, warn: false
    alias KrystalMathApi.Repo
    alias  KrystalMathApi.Projects.{Project,LiveIssue}

    # projects context
    ### SEARCH METHODS ######

    # search for projects
    def all_project_search(search_term) do
      search_name = "%#{search_term}%"
          Repo.all(from(p in Project,
          where: like(p.name, ^search_name)))
          |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end
  # search for projects filtered by project category (Operational, Strategic)
  def project_category_search(category_type,search_term) do
    search_name = "%#{search_term}%"
       Repo.all(from(p in Project,
       where: like(p.name, ^search_name) and  p.project_category_type_id == ^category_type))
       |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end
         # search for projects filtered by project category (Operational, Strategic) and team id and project Type
  def project_type_search(category_type, project_type,search_term) do
    search_name = "%#{search_term}%"
       Repo.all(from(p in Project,
       where: like(p.name, ^search_name) and p.project_category_type_id == ^category_type and p.project_type_id == ^project_type ))
       |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end

    ### Team Search 
         # search all team projects 
  def team_project_search(team_id, search_term) do
    search_name = "%#{search_term}%"
       Repo.all(from(p in Project,
       where: like(p.name, ^search_name) and  p.team_id == ^team_id))
       |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end
     # search for projects filtered by project category (Operational, Strategic) and team id 
  def team_project_category_search(category_type, team_id, search_term) do
    search_name = "%#{search_term}%"
       Repo.all(from(p in Project,
       where: like(p.name, ^search_name) and p.project_category_type_id == ^category_type and p.team_id == ^team_id))
       |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end

      # search for projects filtered by project category (Operational, Strategic) and team id and project Type
  def team_project_type_search(category_type, project_type, team_id, search_term) do
    search_name = "%#{search_term}%"
       Repo.all(from(p in Project,
       where: like(p.name, ^search_name) and p.project_category_type_id == ^category_type and p.project_type_id == ^project_type and p.team_id == ^team_id))
       |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end
    
    def get_all_projects do
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id])
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end
    # get project by Id
    def get_project!(id) do
        Project
        |> Repo.get!(id)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    # Team project by project category
    def team_projects_category_type(team_id, category_type) do
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^category_type and p.team_id == ^team_id)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

     # Team project by project type
     def get_team_projects_type(team_id, project_type) do
      all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_type_id == ^project_type and p.team_id == ^team_id)
      Repo.all(all_projects)
      |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
     end

############ Team project by project category & project type
    def team_projects_category_project_type(team_id, category_type, project_type) do
      all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^category_type and p.project_type_id == ^project_type and p.team_id == ^team_id)
      Repo.all(all_projects)
      |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
  end

############# OPERATIONAL PROJETCS ########
    def operational_projects do
        operation_key = 1
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^operation_key)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    def unassigned_operational_projects do
        operation_key = 1
        team_id = 1
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^operation_key and p.team_id == ^team_id)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    def operational_projects_type(project_type) do
        operation_key = 1
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^operation_key and p.project_type_id == ^project_type)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end


    # All team Projects
    def team_projects(team_id) do
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.team_id == ^team_id)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    # get team project using  project types
    def team_operational_projects_type(team_id,project_type) do
        operation_key = 1
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^operation_key and p.team_id == ^team_id and p.project_type_id == ^project_type)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

 
########### Strategic Projects #########


    # strategic projects
    def strategic_projects do
        strategic_key = 2
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^strategic_key)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    def unassigned_strategic_projects do
        strategic_key = 2
        team_id = 1
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^strategic_key and p.team_id == ^team_id)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

    def strategic_projects_type(project_type) do
        strategic_key = 2
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^strategic_key and p.project_type_id == ^project_type)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end

# get all strategic team project 

      # get team project using  project types
    def team_strategic_projects_type(team_id, project_type) do
        strategic_key = 2
        all_projects = from(p in Project, order_by: [desc: p.priority_type_id], where: p.project_category_type_id == ^strategic_key and p.team_id == ^team_id and p.project_type_id == ^project_type)
        Repo.all(all_projects)
        |> Repo.preload([:team, :user, :project_type, :project_category_type, :project_status, :priority_type])
    end


    @doc """
    create new project record
    """
    def create_project(attrs \\ %{}) do
        %Project{}
        |> Project.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    update project  record
    """

    def update_project(%Project{} = project, attrs) do
        project
        |> Project.changeset(attrs)
        |> Repo.update()
    end

########### Live Issues ############

# Search Live Issues #########
    # search for projects
    def all_live_issues_search(search_term) do
      search_name = "%#{search_term}%"
          Repo.all(from(p in LiveIssue,
          where: like(p.name, ^search_name)))
          |> Repo.preload([:team, :user, :project_status, :priority_type])
    end
        # search for projects
        def all_team_live_issues_search(team_id, search_term) do
          search_name = "%#{search_term}%"
              Repo.all(from(p in LiveIssue,
              where: like(p.name, ^search_name) and p.team_id == ^team_id) )
              |> Repo.preload([:team, :user, :project_status, :priority_type])
        end



    # get live issue by Id
    def get_live_issue!(id) do
      LiveIssue
      |> Repo.get!(id)
      |> Repo.preload([:team, :user, :project_status, :priority_type])
  end
# Get all live issues 
def all_live_issues do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id])
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end

# Get all live issues filter by status
def all_live_issues_status(status_type) do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.project_status_id == ^status_type)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end


# Get all team  live issues 
def all_team_live_issues(team_id) do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.team_id == ^team_id)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end
# Get all team  live issues by status type
def team_live_issues_by_status(team_id,status_type) do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.team_id == ^team_id and  p.project_status_id == ^status_type)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end
# Get all active team  live issues 
def all_active_team_live_issues(team_id) do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.team_id == ^team_id and p.is_active == true)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end
# Get all not active team  live issues 
def all_not_active_team_live_issues(team_id) do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.team_id == ^team_id and p.is_active == false)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end
# Get all comleted active team  live issues 
def all_completed_team_live_issues(team_id) do
  completion_key = 8
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.team_id == ^team_id and p.is_active == false and p.project_status_id == ^completion_key )
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end

    @doc """
    create new live issue record
    """
    def create_live_issue(attrs \\ %{}) do
      %LiveIssue{}
      |> LiveIssue.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  update project  record
  """

  def update_live_issue(%LiveIssue{} = live_issue, attrs) do
    live_issue
      |> LiveIssue.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  update status  record
  """

  def update_status_live_issue(%LiveIssue{} = live_issue, attrs) do
    live_issue
    |> LiveIssue.status_changeset(attrs)
    |> Repo.update()
  end

      @doc """
    delete Live Issue Record
    """
    def delete_live_issues(%LiveIssue{} = live_issue) do
      Repo.delete(live_issue)
    end

#########  COUNTERS ##########################

# project counters
def all_projects_counter do
    projects = from(p in Project,
    select: %{projects_count: count(p.id)})
    Repo.all(projects)
  end


  def project_counter_category(category_id) do
    projects = from(p in Project,
    select: %{projects_count: count(p.id)}, where: p.project_category_type_id == ^category_id)
    Repo.all(projects)
  end


#   assigend team assigned  counters
  def all_assigned_projects_counter do
    team_id = 1
    projects = from(p in Project,
    select: %{assigned_projects_count: count(p.id)}, where: p.team_id != ^team_id)
    Repo.all(projects)
  end
  def all_not_assigned_projects_counter do
    team_id = 1
    projects = from(p in Project,
    select: %{not_assigned_projects: count(p.id)}, where: p.team_id == ^team_id)
    Repo.all(projects)
  end
  
#   completion counters
  def all_pending_projects_counter do
    status_id = 8
    projects = from(p in Project,
    select: %{pending_projects: count(p.id)}, where: p.project_status_id != ^status_id)
    Repo.all(projects)
  end
  
  def all_completed_projects_counter do
    status_id = 8
    projects = from(p in Project,
    select: %{completed_projects: count(p.id)}, where: p.project_status_id == ^status_id)
    Repo.all(projects)
  end


  # All Project Status Counters
def projects_not_started_status do
    status_key = 1
    status = from(p in Project,
    select: %{not_started: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_planning_status do
  
    status_key = 2
    status = from(p in Project,
    select: %{planning: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_investigation_status do
    status_key = 3
    status = from(p in Project,
    select: %{under_investigation: count(p.project_status_id)}, where: p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_hold_status do
    status_key = 4
    status = from(p in Project,
    select: %{on_hold: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_progress_status do
    status_key = 5
    status = from(p in Project,
    select: %{in_progress: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_dev_complete_status do
    status_key = 6
    status = from(p in Project,
    select: %{dev_complete: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end
  def projects_qa_status do
    status_key = 7
    status = from(p in Project,
    select: %{qa: count(p.project_status_id)}, where:  p.project_status_id == ^status_key)
    Repo.all(status)
  end
  def projects_deployed_status do
    status_key = 8
    status = from(p in Project,
    select: %{deployed: count(p.project_status_id)}, where:  p.project_status_id == ^status_key )
    Repo.all(status)
  end


# Project category Counters (Operational, Stratg)
  
  def projects_not_started_status_category_type(category_type) do
    status_key = 1
    status = from(p in Project,
    select: %{not_started: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_planning_status_category_type(category_type) do
    status_key = 2
    status = from(p in Project,
    select: %{planning: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_investigation_status_category_type(category_type) do
    status_key = 3
    status = from(p in Project,
    select: %{under_investigation: count(p.project_status_id)}, where: p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_hold_status_category_type(category_type) do
    status_key = 4
    status = from(p in Project,
    select: %{on_hold: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_progress_status_category_type(category_type) do
    status_key = 5
    status = from(p in Project,
    select: %{in_progress: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_dev_complete_status_category_type(category_type) do
    status_key = 6
    status = from(p in Project,
    select: %{dev_complete: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def projects_qa_status_category_type(category_type) do
    status_key = 7
    status = from(p in Project,
    select: %{qa: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_status_id == ^category_type)
    Repo.all(status)
  end
  def projects_deployed_status_category_type(category_type) do
    status_key = 8
    status = from(p in Project,
    select: %{deployed: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type )
    Repo.all(status)
  end



######### Team Projects Counters ############

def team_projects_counter(team_id) do 
    projects = from(p in Project,
    select: %{projects_count: count(p.id)}, where: p.team_id == ^team_id)
    Repo.all(projects)
  end
  
  # Completed Team Projects
  def team_completed_projects_counter(team_id) do
    status_key = 8
    projects = from(p in Project,
    select: %{completed_projects: count(p.id)}, where: p.team_id == ^team_id and p.project_status_id == ^status_key )
    Repo.all(projects)
  end

  # Pending completion
  def team_pending_projects_counter(team_id) do
    status_key = 8
    projects = from(p in Project,
    select: %{pending_projects: count(p.id)}, where: p.team_id == ^team_id and p.project_status_id != ^status_key )
    Repo.all(projects)
  end
# Project Counters By Category
  def team_projects_category_counter(team_id, category_id) do 
    projects = from(p in Project,
    select: %{projects_count: count(p.id)}, where: p.team_id == ^team_id and p.project_category_type_id == ^category_id )
    Repo.all(projects)
  end
  
  # Completed Team Projects
  def team_completed_projects_category_counter(team_id, category_id) do
    status_key = 8
    projects = from(p in Project,
    select: %{completed_projects: count(p.id)}, where: p.team_id == ^team_id and p.project_category_type_id == ^category_id  and p.project_status_id == ^status_key )
    Repo.all(projects)
  end

  # Pending completion
  def team_pending_projects_category_counter(team_id, category_id) do
    status_key = 8
    projects = from(p in Project,
    select: %{pending_projects: count(p.id)}, where: p.team_id == ^team_id and p.project_category_type_id == ^category_id and p.project_status_id != ^status_key )
    Repo.all(projects)
  end

#  All Team Project Status Counters
  def team_projects_not_started_status_category_type(team_id,category_type) do
    status_key = 1
    status = from(p in Project,
    select: %{not_started: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_planning_status_category_type(team_id, category_type) do
  
    status_key = 2
    status = from(p in Project,
    select: %{planning: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_investigation_status_category_type(team_id, category_type) do
    status_key = 3
    status = from(p in Project,
    select: %{under_investigation: count(p.project_status_id)}, where: p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_hold_status_category_type(team_id, category_type) do
    status_key = 4
    status = from(p in Project,
    select: %{on_hold: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_progress_status_category_type(team_id, category_type) do
    status_key = 5
    status = from(p in Project,
    select: %{in_progress: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_dev_complete_status_category_type(team_id, category_type) do
    status_key = 6
    status = from(p in Project,
    select: %{dev_complete: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_qa_status_category_type(team_id, category_type) do
    status_key = 7
    status = from(p in Project,
    select: %{qa: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.all(status)
  end
  def team_projects_deployed_status_category_type(team_id, category_type) do
    status_key = 8
    status = from(p in Project,
    select: %{deployed: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type )
    Repo.all(status)
  end


 def team_project_status_count(team_id,category_type) do
      one = team_projects_not_started_status_category_type(team_id, category_type)
      two = team_projects_planning_status_category_type(team_id, category_type)
    Repo.all([one, two])
 end





  # Team overview Counts
  def team_overview_projects_not_started(team_id) do
    status_key = 1
    status = from(p in Project,
    select: %{not_started: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id)
    Repo.all(status)
  end
  def team_overview_projects_planning(team_id) do
  
    status_key = 2
    status = from(p in Project,
    select: %{planning: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_investigation(team_id) do
    status_key = 3
    status = from(p in Project,
    select: %{under_investigation: count(p.project_status_id)}, where: p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_hold(team_id) do
    status_key = 4
    status = from(p in Project,
    select: %{on_hold: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_progress(team_id) do
    status_key = 5
    status = from(p in Project,
    select: %{in_progress: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_dev_complete(team_id) do
    status_key = 6
    status = from(p in Project,
    select: %{dev_complete: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_qa(team_id) do
    status_key = 7
    status = from(p in Project,
    select: %{qa: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end
  def team_overview_projects_deployed(team_id) do
    status_key = 8
    status = from(p in Project,
    select: %{deployed: count(p.project_status_id)}, where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.all(status)
  end



  ############### Live Issues Counters ###############
    
    def active_live_issues do
      status_key = 8
      live_issue = from(p in LiveIssue,
      select: %{live_issues_counter: count(p.id)}, where: p.project_status_id != ^status_key  and p.is_active == true)
      Repo.all(live_issue)
    end

    # Active Team Live Issue Projects
    def active_team_live_issues(team_id) do
      status_key = 8
      live_issue = from(p in LiveIssue,
      select: %{live_issues_counter: count(p.id)}, where: p.team_id == ^team_id and p.project_status_id != ^status_key and p.is_active == true)
      Repo.all(live_issue)
    end

end