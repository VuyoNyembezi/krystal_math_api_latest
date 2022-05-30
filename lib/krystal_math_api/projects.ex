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

    # search for all  active projects
        def all_active_live_issues_search(search_term) do
          search_name = "%#{search_term}%"
              Repo.all(from(p in LiveIssue,
              where: like(p.name, ^search_name) and p.is_active == true))
              |> Repo.preload([:team, :user, :project_status, :priority_type])
        end

    # search for all  not active projects
        def all_not_active_live_issues_search(search_term) do
          completion_key = 8
            search_name = "%#{search_term}%"
                Repo.all(from(p in LiveIssue,
                where: like(p.name, ^search_name) and p.is_active == false and p.project_status_id != ^completion_key))
                |> Repo.preload([:team, :user, :project_status, :priority_type])
        end

    # search for all completed projects
        def all_completed_active_live_issues_search(search_term) do
          completion_key = 8
            search_name = "%#{search_term}%"
              Repo.all(from(p in LiveIssue,
              where: like(p.name, ^search_name) and p.is_active == false and p.project_status_id == ^completion_key))
            |> Repo.preload([:team, :user, :project_status, :priority_type])
          end


        # Team Search
        
        
  # search for projects
        def all_team_live_issues_search(team_id, search_term) do
          search_name = "%#{search_term}%"
              Repo.all(from(p in LiveIssue,
              where: like(p.name, ^search_name) and p.team_id == ^team_id) )
              |> Repo.preload([:team, :user, :project_status, :priority_type])
        end
  # active search for projects
  def active_team_live_issues_search(team_id, search_term) do
    search_name = "%#{search_term}%"
        Repo.all(from(p in LiveIssue,
        where: like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == true) )
        |> Repo.preload([:team, :user, :project_status, :priority_type])
  end
    # not active search for projects
    def not_active_team_live_issues_search(team_id, search_term) do
      completion_key = 8
      search_name = "%#{search_term}%"
          Repo.all(from(p in LiveIssue,
          where: like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == false and p.project_status_id != ^completion_key) )
          |> Repo.preload([:team, :user, :project_status, :priority_type])
    end
      # completed search for projects
      def completed_team_live_issues_search(team_id, search_term) do
        completion_key = 8
        search_name = "%#{search_term}%"
            Repo.all(from(p in LiveIssue,
            where: like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == false and p.project_status_id == ^completion_key) )
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

# Get all active  live issues 
def all_active_live_issues do
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where:  p.is_active == true)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end
# Get all not active  live issues 
def all_not_active_live_issues do
  completion_key = 8
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.is_active == false and p.project_status_id != ^completion_key)
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end

# Get all comleted active  live issues 
def all_completed_live_issues do
  completion_key = 8
  all_projects = from(p in LiveIssue, order_by: [desc: p.priority_type_id],where: p.is_active == false and p.project_status_id == ^completion_key )
  Repo.all(all_projects)
  |> Repo.preload([:team, :user, :project_status, :priority_type])
end







# Team
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
    select: count(p.id))
    Repo.one(projects)
  end
  #   assigend team assigned  counters
  def all_assigned_projects_counter do
    team_id = 1
    projects = from(p in Project,
    select: count(p.id), where: p.team_id != ^team_id)
    Repo.one(projects)
  end
  def all_not_assigned_projects_counter do
    team_id = 1
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id)
    Repo.one(projects)
  end

  #   completion counters
  def all_pending_projects_counter do
    status_id = 8
    projects = from(p in Project,
    select: count(p.id), where: p.project_status_id != ^status_id)
    Repo.one(projects)
  end
  
  def all_completed_projects_counter do
    status_id = 8
    projects = from(p in Project,
    select: count(p.id), where: p.project_status_id == ^status_id)
    Repo.one(projects)
  end
  ####@@@@ LATEST @@@@####
@doc """
calls all projects filter by category and map the into a single varibale
iex> projects_counter(1)
"""

  def projects_counter() do
    projects_count =%{
      all_project: all_projects_counter() ,
      not_assigned: all_not_assigned_projects_counter() ,
      assigned: all_assigned_projects_counter() ,
      pending: all_pending_projects_counter(),
      completed: all_completed_projects_counter()
  }
  projects_count
  end




  def project_counter_category(category_id) do
    projects = from(p in Project,
    select: %{projects_count: count(p.id)}, where: p.project_category_type_id == ^category_id)
    Repo.one(projects)
  end

  # All Project Status Counters
  def projects_not_started_status do
    status_key = 1
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_planning_status do
  
    status_key = 2
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_investigation_status do
    status_key = 3
    status = from(p in Project,
    select: count(p.project_status_id), where: p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_hold_status do
    status_key = 4
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_progress_status do
    status_key = 5
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_dev_complete_status do
    status_key = 6
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def projects_qa_status do
    status_key = 7
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key)
    Repo.one(status)
  end
  def projects_deployed_status do
    status_key = 8
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  ####@@@@ LATEST @@@@####
  @doc """
calls all projects statuses count map the into a single varibale
iex> projects_statuses(1)
"""
  def projects_statuses() do
    projects_statuses_count =%{
      not_started: projects_not_started_status() ,
      planning: projects_planning_status() ,
      under_investigation: projects_investigation_status() ,
      on_hold: projects_hold_status(),
      in_progress: projects_progress_status(),
      dev_complete: projects_dev_complete_status() ,
      qa: projects_qa_status(),
      deployed: projects_deployed_status()

    }
    projects_statuses_count
  end



# Project category Counters (Operational, Stratg)
  
  def projects_not_started_status_category_type(category_type) do
    status_key = 1
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_planning_status_category_type(category_type) do
    status_key = 2
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_investigation_status_category_type(category_type) do
    status_key = 3
    status = from(p in Project,
    select:  count(p.project_status_id), where: p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_hold_status_category_type(category_type) do
    status_key = 4
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_progress_status_category_type(category_type) do
    status_key = 5
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_dev_complete_status_category_type(category_type) do
    status_key = 6
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def projects_qa_status_category_type(category_type) do
    status_key = 7
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_status_id == ^category_type)
    Repo.one(status)
  end
  def projects_deployed_status_category_type(category_type) do
    status_key = 8
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.project_category_type_id == ^category_type )
    Repo.one(status)
  end
  ####@@@@ LATEST @@@@####
  @doc """
calls all projects statuses count map the into a single varibale and filter it by project category
iex> projects_statuses_category(1)
"""
  def projects_statuses_category(category_type) do
    projects_statuses_category_count =%{
      not_started: projects_not_started_status_category_type(category_type) ,
      planning: projects_planning_status_category_type(category_type) ,
      under_investigation: projects_investigation_status_category_type(category_type) ,
      on_hold: projects_hold_status_category_type(category_type),
      in_progress: projects_progress_status_category_type(category_type),
      dev_complete: projects_dev_complete_status_category_type(category_type) ,
      qa: projects_qa_status_category_type(category_type),
      deployed: projects_deployed_status_category_type(category_type)

    }
    projects_statuses_category_count
  end


######### Team Projects Counters ############

def team_projects_counter_all(team_id) do 
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id)
    Repo.one(projects)
  end
  
  # Completed Team Projects
  def team_completed_projects_counter(team_id) do
    status_key = 8
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id and p.project_status_id == ^status_key )
    Repo.one(projects)
  end

  # Pending completion
  def team_pending_projects_counter(team_id) do
    status_key = 8
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id and p.project_status_id != ^status_key )
    Repo.one(projects)
  end

  # Team projects 
  def team_projects_counter(team_id) do
    team_projects_count =%{
    all_project: team_projects_counter_all(team_id) ,
    pending: team_pending_projects_counter(team_id),
    completed: team_completed_projects_counter(team_id)
  }
  team_projects_count
  end


# Project Counters By Category
  def team_projects_category_counter_all(team_id, category_id) do 
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id and p.project_category_type_id == ^category_id )
    Repo.one(projects)
  end
  
  # Completed Team Projects
  def team_completed_projects_category_counter(team_id, category_id) do
    status_key = 8
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id and p.project_category_type_id == ^category_id  and p.project_status_id == ^status_key )
    Repo.one(projects)
  end

  # Pending completion
  def team_pending_projects_category_counter(team_id, category_id) do
    status_key = 8
    projects = from(p in Project,
    select: count(p.id), where: p.team_id == ^team_id and p.project_category_type_id == ^category_id and p.project_status_id != ^status_key )
    Repo.one(projects)
  end
   ####@@@@ LATEST @@@@####
  @doc """
calls all projects overview counts map the into a single varibale
iex> team_projects_category_counter(1)
"""
def team_projects_category_counter(team_id, category_id) do
  team_projects_count =%{all_project: team_projects_category_counter_all(team_id, category_id) ,
  pending: team_pending_projects_category_counter(team_id, category_id),
  completed: team_completed_projects_category_counter(team_id, category_id)
}
team_projects_count
end




#  All Team Project Status Counters
  def team_projects_not_started_status_category_type(team_id,category_type) do
    status_key = 1
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_planning_status_category_type(team_id, category_type) do
  
    status_key = 2
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_investigation_status_category_type(team_id, category_type) do
    status_key = 3
    status = from(p in Project,
    select: count(p.project_status_id), where: p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_hold_status_category_type(team_id, category_type) do
    status_key = 4
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_progress_status_category_type(team_id, category_type) do
    status_key = 5
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_dev_complete_status_category_type(team_id, category_type) do
    status_key = 6
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_qa_status_category_type(team_id, category_type) do
    status_key = 7
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type)
    Repo.one(status)
  end
  def team_projects_deployed_status_category_type(team_id, category_type) do
    status_key = 8
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id and p.project_category_type_id == ^category_type )
    Repo.one(status)
  end


 def team_project_category_status_count(team_id, category_type) do 
  team_projects_category_statuses_count =%{
    not_started: team_projects_not_started_status_category_type(team_id,category_type) ,
    planning: team_projects_planning_status_category_type(team_id,category_type) ,
    under_investigation: team_projects_investigation_status_category_type(team_id,category_type) ,
    on_hold: team_projects_hold_status_category_type(team_id,category_type),
    in_progress: team_projects_progress_status_category_type(team_id,category_type),
    dev_complete: team_projects_dev_complete_status_category_type(team_id,category_type) ,
    qa: team_projects_qa_status_category_type(team_id,category_type),
    deployed: team_projects_deployed_status_category_type(team_id,category_type)
  }
  team_projects_category_statuses_count
 end

  # Team overview Counts
  def team_overview_projects_not_started(team_id) do
    status_key = 1
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id)
    Repo.one(status)
  end
  def team_overview_projects_planning(team_id) do
  
    status_key = 2
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_investigation(team_id) do
    status_key = 3
    status = from(p in Project,
    select:  count(p.project_status_id), where: p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_hold(team_id) do
    status_key = 4
    status = from(p in Project,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_progress(team_id) do
    status_key = 5
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_dev_complete(team_id) do
    status_key = 6
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_qa(team_id) do
    status_key = 7
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_overview_projects_deployed(team_id) do
    status_key = 8
    status = from(p in Project,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_project_status_count(team_id) do 
    team_projects_statuses_count =%{
      not_started: team_overview_projects_not_started(team_id) ,
      planning: team_overview_projects_planning(team_id) ,
      under_investigation: team_overview_projects_investigation(team_id) ,
      on_hold: team_overview_projects_hold(team_id),
      in_progress: team_overview_projects_progress(team_id),
      dev_complete: team_overview_projects_dev_complete(team_id) ,
      qa: team_overview_projects_qa(team_id),
      deployed: team_overview_projects_deployed(team_id)
    }
    team_projects_statuses_count
  end


  ############### Live Issues Counters ###############
    


    #  Team Live Issue Projects Overview
    def active_live_issues do
      status_key = 8
      live_issue = from(p in LiveIssue,
      select: count(p.id), where: p.project_status_id != ^status_key and p.is_active == true)
      Repo.one(live_issue)
    end

  # Completed Team Live Projects
  def completed_live_issues do
    status_key = 8
    projects = from(p in LiveIssue,
    select: count(p.id), where:  p.project_status_id == ^status_key and p.is_active == false)
    Repo.one(projects)
  end

  def all_live_issues_overview do
    live_issue = from(p in LiveIssue,
    select: count(p.id)  )
    Repo.one(live_issue)
  end
  # Pending completion
  def pending_live_issues do
    status_key = 8
    projects = from(p in LiveIssue,
    select: count(p.id), where:  p.project_status_id != ^status_key and p.is_active == true )
    Repo.one(projects)
  end

  def live_issues_count_overview() do 
    live_issues_count =%{
      completed: completed_live_issues() ,
      pending: pending_live_issues() ,
      all_project: all_live_issues_overview(),
      active:  active_live_issues()
    }
    live_issues_count
  end




  # All Project Status Counters
  def live_issue_not_started_status do
    status_key = 1
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_planning_status do
  
    status_key = 2
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_investigation_status do
    status_key = 3
    status = from(p in LiveIssue,
    select: count(p.project_status_id), where: p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_hold_status do
    status_key = 4
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_progress_status do
    status_key = 5
    status = from(p in LiveIssue,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_dev_complete_status do
    status_key = 6
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  def live_issue_qa_status do
    status_key = 7
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key)
    Repo.one(status)
  end
  def live_issue_deployed_status do
    status_key = 8
    status = from(p in LiveIssue,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key )
    Repo.one(status)
  end
  ####@@@@ LATEST @@@@####
  @doc """
calls all live_issue statuses count map the into a single varibale
iex> live_issue_statuses(1)
"""
  def live_issue_statuses() do
    live_issue_statuses_count =%{
      not_started: live_issue_not_started_status() ,
      planning: live_issue_planning_status() ,
      under_investigation: live_issue_investigation_status() ,
      on_hold: live_issue_hold_status(),
      in_progress: live_issue_progress_status(),
      dev_complete: live_issue_dev_complete_status() ,
      qa: live_issue_qa_status(),
      deployed: live_issue_deployed_status()

    }
    live_issue_statuses_count
  end



# TEAM


    #  Team Live Issue Projects Overview
    def active_team_live_issues(team_id) do
      status_key = 8
      live_issue = from(p in LiveIssue,
      select: count(p.id), where: p.team_id == ^team_id and p.project_status_id != ^status_key and p.is_active == true)
      Repo.one(live_issue)
    end

  # Completed Team Live Projects
  def team_completed_live_issues(team_id) do
    status_key = 8
    projects = from(p in LiveIssue,
    select: count(p.id), where: p.team_id == ^team_id and p.project_status_id == ^status_key and p.is_active == false)
    Repo.one(projects)
  end

  def team_all_live_issues(team_id) do
    live_issue = from(p in LiveIssue,
    select: count(p.id), where: p.team_id == ^team_id  )
    Repo.one(live_issue)
  end
  # Pending completion
  def team_pending_live_issues(team_id) do
    status_key = 8
    projects = from(p in LiveIssue,
    select: count(p.id), where: p.team_id == ^team_id and p.project_status_id != ^status_key and p.is_active == true )
    Repo.one(projects)
  end

  def team_live_issues_count(team_id) do 
    team_live_issues_count =%{
      completed: team_completed_live_issues(team_id) ,
      pending: team_pending_live_issues(team_id) ,
      all_project: team_all_live_issues(team_id),
      active:  active_team_live_issues(team_id)
    }
    team_live_issues_count
  end

  # Team Live Issues Status overview Counts
  def team_live_issues_not_started(team_id) do
    status_key = 1
    status = from(p in LiveIssue,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id)
    Repo.one(status)
  end
  def team_live_issues_planning(team_id) do
  
    status_key = 2
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_investigation(team_id) do
    status_key = 3
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where: p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_hold(team_id) do
    status_key = 4
    status = from(p in LiveIssue,
    select: count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_progress(team_id) do
    status_key = 5
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_dev_complete(team_id) do
    status_key = 6
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_qa(team_id) do
    status_key = 7
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end
  def team_live_issues_deployed(team_id) do
    status_key = 8
    status = from(p in LiveIssue,
    select:  count(p.project_status_id), where:  p.project_status_id == ^status_key and p.team_id == ^team_id )
    Repo.one(status)
  end

  def team_live_issues_status_count(team_id) do 
    team_live_statuses_count =%{
      not_started: team_live_issues_not_started(team_id) ,
      planning: team_live_issues_planning(team_id) ,
      under_investigation: team_live_issues_investigation(team_id) ,
      on_hold: team_live_issues_hold(team_id),
      in_progress: team_live_issues_progress(team_id),
      dev_complete: team_live_issues_dev_complete(team_id) ,
      qa: team_live_issues_qa(team_id),
      deployed: team_live_issues_deployed(team_id)
    }
    team_live_statuses_count
  end

end