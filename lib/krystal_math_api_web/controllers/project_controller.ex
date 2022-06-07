defmodule KrystalMathApiWeb.ProjectController do
    use KrystalMathApiWeb, :controller
    alias KrystalMathApi.Projects
    alias KrystalMathApi.Projects.{Project, LiveIssue}

    action_fallback KrystalMathApiWeb.FallbackController


    def all_projects(conn, _params) do
        projects = Projects.get_all_projects()
        render(conn,"index.json", projects: projects)
    end

    def project_by_id(conn, %{"id" => id}) do
      project = Projects.get_project!(id)
      render(conn,"show.json", project: project)
  end


  ##### Search Methods ###
    # search all projects 
    def all_projects_search(conn, %{"search" => search_term}) do
      projects = Projects.all_project_search(search_term)
      render(conn,"index.json", projects: projects)
    end

    # search projects  by category e.g( Operational, Strategic)
    def projects_operational_category_search(conn, %{"search" => search_term}) do
      projects = Projects.project_operational_category_search(search_term)
      render(conn,"index.json", projects: projects)
    end
    def projects_strategic_category_search(conn, %{"search" => search_term}) do
      projects = Projects.project_strategic_category_search(search_term)
      render(conn,"index.json", projects: projects)
    end


    # search projects  by category e.g( Operational, Strategic) and project type
      # Map category search 
      def search_operational_projects(conn, %{"search" => search_term}) do
          project = Projects.all_operational_project_type_search(search_term)
          render(conn,"project_overview.json", project: project)
      end
      def search_strategic_projects(conn, %{"search" => search_term}) do
        project = Projects.all_strategic_project_type_search(search_term)
        render(conn,"project_overview.json", project: project)
    end
    
    # search projects  by category and team id  e.g( Operational, Strategic)
      def team_projects_category_search(conn, %{"category_type" => category_type,"team_id" => team_id,"search" => search_term}) do
        projects = Projects.team_project_category_search(category_type,team_id,search_term)
        render(conn,"index.json", projects: projects)
      end
      def team_search_strategic_projects(conn, %{"team_id" => team_id,"search" => search_term}) do
        projects = Projects.team_strategic_project_search(team_id,search_term)
        render(conn,"index.json", projects: projects)
    end
    def team_search_operational_projects(conn, %{"team_id" => team_id,"search" => search_term}) do
      projects = Projects.team_operational_project_search(team_id,search_term)
      render(conn,"index.json", projects: projects)
  end

   # search all team projects 
   def all_team_projects_search(conn, %{"team_id" => team_id,"search" => search_term}) do
    projects = Projects.team_project_search(team_id,search_term)
    render(conn,"index.json", projects: projects)
  end


    # search projects  by category and team id  e.g(, Operational, Strategic)
      def team_projects_type_search(conn, %{"category_type" => category_type,"project_type" => project_type,"team_id" => team_id,"search" => search_term}) do
        projects = Projects.team_project_type_search(category_type,team_id,project_type,search_term)
        render(conn,"index.json", projects: projects)
      end

      def team_search_strategic_projects_project_type(conn, %{"team_id" => team_id,"search" => search_term}) do
        project = Projects.team_strategic_project_type_search(team_id,search_term)
        render(conn,"project_overview.json", project: project)
    end
    def team_search_operational_projects_project_type(conn, %{"team_id" => team_id,"search" => search_term}) do
      project = Projects.team_operational_project_type_search(team_id,search_term)
      render(conn,"project_overview.json", project: project)
    end


    # Operational Projects

    def all_operational_projects(conn, _params) do
        projects = Projects.operational_projects()
        render(conn,"index.json", projects: projects)
    end
    def all_un_assigned_operational_projects(conn, _params) do
        projects = Projects.unassigned_operational_projects()
        render(conn,"index.json", projects: projects)
    end


# Map 
    def get_operational_projects_types(conn, _params) do
      project = Projects.get_operational_projects_type()
      render(conn,"project_overview.json", project: project)
  end

     # Strategic Projects

     def all_strategic_projects(conn, _params) do
        projects = Projects.strategic_projects()
        render(conn,"index.json", projects: projects)
    end

    def all_un_assigned_strategic_projects(conn, _params) do
        projects = Projects.unassigned_strategic_projects()
        render(conn,"index.json", projects: projects)
    end
# Map Strategic 
def get_strategic_projects_types(conn, _params) do
  project = Projects.get_strategic_projects_type()
  render(conn,"project_overview.json", project: project)
end


# TEAM Project BASED CONTROLLERS
def team_projects(conn, %{"team_id" => team_id}) do
        projects = Projects.team_projects(team_id)
        render(conn,"index.json", projects: projects)
end

# Team projects by category (Operational, Strategic)

def team_projects_by_category(conn, %{"team_id" => team_id,"category_type" => category_type}) do
    projects = Projects.team_projects_category_type(team_id, category_type)
    render(conn,"index.json", projects: projects)
end

# Team Projects by type

def team_projects_type(conn, %{"team_id" => team_id}) do
  project = Projects.get_all_team_projects_type(team_id)
  render(conn,"project_overview.json", project: project)
end








# Team projects by category (Operational, Strategic)

def team_projects_by_type_and_category(conn, %{"team_id" => team_id,"category_type" => category_type,"project_type" => project_type}) do
  projects = Projects.team_projects_category_project_type(team_id, category_type, project_type)
  render(conn,"index.json", projects: projects)
end
# Operational Projects

def team_operational_project_types(conn, %{"team_id" => team_id}) do
  project = Projects.get_team_operational_projects_type(team_id)
  render(conn,"project_overview.json", project: project)
end


# Strategic Projects
def team_strategic_project_types(conn, %{"team_id" => team_id}) do
  project = Projects.get_team_strategic_projects_type(team_id)
  render(conn,"project_overview.json", project: project)
end



# Create New Record

def create_new_project(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> render("project.json", project: project)
    end
end
# Update Project Record

def update_project(conn, %{"id" => id, "project"=> project_params}) do
    project = Projects.get_project!(id)
    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params ) do
      render(conn, "show.json", project: project)
    end
end

########### Live Issues ############
# search live issues
def live_issuses_search(conn, %{"search" => search_term}) do
  live_issues = Projects.all_live_issues_search(search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# active 
# search live issues
def active_live_issuses_search(conn, %{"search" => search_term}) do
  live_issues = Projects.all_active_live_issues_search(search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# not active 
# search live issues
def not_active_live_issuses_search(conn, %{"search" => search_term}) do
  live_issues = Projects.all_not_active_live_issues_search(search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# Completed
# search live issues
def completed_live_issuses_search(conn, %{"search" => search_term}) do
  live_issues = Projects.all_completed_active_live_issues_search(search_term)
  render(conn, "index.json", live_issues: live_issues )
end



# search team live issues
def team_live_issuses_search(conn, %{"team_id" => team_id,"search" => search_term}) do
  live_issues = Projects.all_team_live_issues_search(team_id,search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# active team projects
def active_team_live_issuses_search(conn, %{"team_id" => team_id,"search" => search_term}) do
  live_issues = Projects.active_team_live_issues_search(team_id,search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# not active projects
def not_active_team_live_issuses_search(conn, %{"team_id" => team_id,"search" => search_term}) do
  live_issues = Projects.not_active_team_live_issues_search(team_id,search_term)
  render(conn, "index.json", live_issues: live_issues )
end
# completed
def completed_team_live_issuses_search(conn, %{"team_id" => team_id,"search" => search_term}) do
  live_issues = Projects.completed_team_live_issues_search(team_id,search_term)
  render(conn, "index.json", live_issues: live_issues )
end









# Get all  live issue projects
def get_live_issuses(conn, _params) do
live_issues = Projects.all_live_issues()
render(conn, "index.json", live_issues: live_issues )
end

# Get all active live issue projects
def get_active_live_issuses(conn, _params) do
  live_issues = Projects.all_active_live_issues()
  render(conn, "index.json", live_issues: live_issues )
  end
  # Get all not active live issue projects
def get_not_active_live_issuses(conn, _params) do
  live_issues = Projects.all_not_active_live_issues()
  render(conn, "index.json", live_issues: live_issues )
  end

  # Get all  live issue projects
def get_completed_live_issuses(conn, _params) do
  live_issues = Projects.all_completed_live_issues()
  render(conn, "index.json", live_issues: live_issues )
  end



# Get all team live issue by  statuse type
def get_live_issues_status(conn, %{"status_type" => status_type}) do
  live_issues = Projects.all_live_issues_status(status_type)
  render(conn, "index.json", live_issues: live_issues )
end
# TEAM
# Get all team live issue projects
def get_all_team_live_issuses(conn, %{"team_id" => team_id}) do
  live_issues = Projects.all_active_team_live_issues(team_id)
  render(conn, "index.json", live_issues: live_issues )
end

# Get all team live issue by status id
def get_all_team_live_issuses_status(conn, %{"team_id" => team_id,"status_type" => status_type}) do
  live_issues = Projects.team_live_issues_by_status(team_id,status_type)
  render(conn, "index.json", live_issues: live_issues )
end
# Get active team live issue projects

def get_active_team_live_issuses(conn, %{"team_id" => team_id}) do
  live_issues = Projects.all_active_team_live_issues(team_id)
  render(conn, "index.json", live_issues: live_issues )
end
# Get not active team live issue projects
  def get_not_active_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = Projects.all_not_active_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues )
  end

  # Get not active team live issue projects
  def get_completed_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = Projects.all_completed_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues )
  end

  # Create New Record

def create_new_live_issue(conn, %{"live_issue" => live_issue_params}) do
  with {:ok, %LiveIssue{} = live_issue} <- Projects.create_live_issue(live_issue_params) do
    conn
    |> put_status(:created)
    |> render("live_issue.json", live_issue: live_issue)
  end
end
# Update Live Issue  Record

def update_live_issue(conn, %{"id" => id, "live_issue"=> live_issue_params}) do
  live_issue = Projects.get_live_issue!(id)
  with {:ok, %LiveIssue{} = live_issue} <- Projects.update_live_issue(live_issue, live_issue_params ) do
    render(conn, "show.json", live_issue: live_issue)
  end
end

# Update live Issue Status Record
def update_live_issue_status(conn, %{"id" => id, "live_issue"=> live_issue_params}) do
  live_issue = Projects.get_live_issue!(id)
  with {:ok, %LiveIssue{} = live_issue} <- Projects.update_status_live_issue(live_issue, live_issue_params ) do
    render(conn, "show.json", live_issue: live_issue)
  end
end

    # Delete Live Issues
    def delete_live_issue(conn, %{"id" => id}) do
      live_issue = Projects.get_live_issue!(id)
      with {:ok,%LiveIssue{} = live_issue} <- Projects.delete_live_issues(live_issue) do
      conn
      |> put_status(200)
      |> text("live issue deleted successfully")
      end
  end

# COUNTERS #####

# All Project Counters 

def projects_counter(conn, _params) do
  project_overview = Projects.projects_counter()
  render(conn, "full_project_overview.json", project_overview: project_overview)
end

# Counter by category
def project_count_by_category(conn, %{"category_type" => category_id}) do
  counter = Projects.project_counter_category(category_id)
  render(conn, "counter_details.json",counter: counter )
end

def project_count_category(conn, _params) do
  project_count = Projects.projects_category_counter()
  render(conn, "projects_counter.json",project_count: project_count )
end


#All Projects Status Counters


  def projects_status_counter(conn, _params) do
    project_statsuses = Projects.projects_statuses()
    render(conn, "project_statuses.json", project_statsuses: project_statsuses)
  end

#   Project Statuses using categories(  Operational, Strategic)
def projects_category_statuses(conn, %{"category_type" => category_type}) do
  project_statsuses = Projects.projects_statuses_category(category_type)
  render(conn, "project_statuses.json", project_statsuses: project_statsuses)
end
def projects_category_statuses_all(conn, _params) do
  project_statsuses = Projects.overview_projects_statuses()
  render(conn, "projects_overview.json", project_statsuses: project_statsuses)
end

################## TEAM COUNTERS #####################


# Team Overview projects counter
def team_projects_count(conn, %{"team_id" => team_id}) do
  project_overview = Projects.team_projects_counter(team_id)
  render(conn, "project_overview.json", project_overview: project_overview)
end

# Team completion Counter Project filter by Category

def team_category_projects_count(conn, %{"team_id" => team_id,"category_id" => category_id}) do
  project_overview = Projects.team_projects_category_counter(team_id,category_id)
  render(conn, "project_overview_status.json", project_overview: project_overview)
end


#Team Project Statuses using categories( Live Issues, Operational, Strategic)
def team_projects_category_statuses(conn, %{"team_id" => team_id,"category_type" => category_type}) do
  project_statsuses = Projects.team_project_category_status_count(team_id,category_type)
  render(conn, "project_statuses.json", project_statsuses: project_statsuses)
end

  #Team Overview Project Counters
  def team_projects_statuses(conn, %{"team_id" => team_id}) do
    project_statsuses = Projects.team_project_status_count(team_id)
    render(conn, "project_statuses.json", project_statsuses: project_statsuses)
  end
 

############# LIVE ISSUES COUNTER    ################

def active_live_issues_counter(conn, _params) do
  live_issues_counter = Projects.active_live_issues()
  render(conn, "index.json", live_issues_counter: live_issues_counter)
end

def live_issues_counter(conn, _params) do
  project_overview = Projects.live_issues_count_overview()
  render(conn, "live_issue_overview.json", project_overview: project_overview)
end


# Live Issues Project status Counter
def live_issue_status_counter(conn, _params) do
  project_statsuses = Projects.live_issue_statuses()
  render(conn, "project_statuses.json", project_statsuses: project_statsuses)
end

# TEAM COUNTERS



def team_live_issues_counter(conn, %{"team_id"=> team_id}) do
  project_overview = Projects.team_live_issues_count(team_id)
  render(conn, "live_issue_overview.json", project_overview: project_overview)
end


  #Team Overview Live Issues Project Statuses Counters
  def team_live_statuses(conn, %{"team_id" => team_id}) do
    project_statsuses = Projects.team_live_issues_status_count(team_id)
    render(conn, "project_statuses.json", project_statsuses: project_statsuses)
  end
end