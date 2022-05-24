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
    def projects_category_search(conn, %{"category_type" => category_type,"search" => search_term}) do
      projects = Projects.project_category_search(category_type,search_term)
      render(conn,"index.json", projects: projects)
    end

    # search projects  by category e.g( Operational, Strategic) and project type
      def projects_type_search(conn, %{"category_type" => category_type,"project_type" => project_type,"search" => search_term}) do
        projects = Projects.project_type_search(category_type,project_type,search_term)
        render(conn,"index.json", projects: projects)
      end
  
    # search projects  by category and team id  e.g( Operational, Strategic)
      def team_projects_category_search(conn, %{"category_type" => category_type,"team_id" => team_id,"search" => search_term}) do
        projects = Projects.team_project_category_search(category_type,team_id,search_term)
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

    # Operational Projects

    def all_operational_projects(conn, _params) do
        projects = Projects.operational_projects()
        render(conn,"index.json", projects: projects)
    end
    def all_un_assigned_operational_projects(conn, _params) do
        projects = Projects.unassigned_operational_projects()
        render(conn,"index.json", projects: projects)
    end

    def all_operational_projects_types(conn, %{"project_type" => project_type}) do
        projects = Projects.operational_projects_type(project_type)
        render(conn,"index.json", projects: projects)
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

    def all_strategic_projects_types(conn, %{"project_type" => project_type}) do
        projects = Projects.strategic_projects_type(project_type)
        render(conn,"index.json", projects: projects)
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

def team_projects_type(conn, %{"team_id" => team_id,"project_type" => project_type}) do
  projects = Projects.get_team_projects_type(team_id, project_type)
  render(conn,"index.json", projects: projects)
end
# Team projects by category (Operational, Strategic)

def team_projects_by_type_and_category(conn, %{"team_id" => team_id,"category_type" => category_type,"project_type" => project_type}) do
  projects = Projects.team_projects_category_project_type(team_id, category_type, project_type)
  render(conn,"index.json", projects: projects)
end
# Operational Projects

def team_operational_project_types(conn, %{"team_id" => team_id, "project_type" => project_type}) do
    projects = Projects.team_operational_projects_type(team_id, project_type)
    render(conn,"index.json", projects: projects)
end

# Strategic Projects

def team_strategic_project_types(conn, %{"team_id" => team_id, "project_type" => project_type}) do
    projects = Projects.team_strategic_projects_type(team_id, project_type)
    render(conn,"index.json", projects: projects)
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
# search team live issues
def team_live_issuses_search(conn, %{"team_id" => team_id,"search" => search_term}) do
  live_issues = Projects.all_team_live_issues_search(team_id,search_term)
  render(conn, "index.json", live_issues: live_issues )
end

# Get all  live issue projects
def get_live_issuses(conn, _params) do
live_issues = Projects.all_live_issues()
render(conn, "index.json", live_issues: live_issues )
end
# Get all team live issue by 
def get_live_issues_status(conn, %{"status_type" => status_type}) do
  live_issues = Projects.all_live_issues_status(status_type)
  render(conn, "index.json", live_issues: live_issues )
end

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

# Overall Project Counters
def project_count(conn, _params) do
    counters = Projects.all_projects_counter()
    render(conn, "index.json",counters: counters )
end

def project_count_by_category(conn, %{"category_type" => category_id}) do
  counters = Projects.project_counter_category(category_id)
  render(conn, "index.json",counters: counters )
end


def assigned_project_count(conn, _params) do
    assigned = Projects.all_assigned_projects_counter()
    render(conn, "index.json",assigned: assigned )
end
def not_assigned_project_count(conn, _params) do
    not_assigned = Projects.all_not_assigned_projects_counter()
    render(conn, "index.json",not_assigned: not_assigned )
end

#Project  Completion 
def pending_project_count(conn, _params) do
    pending = Projects.all_pending_projects_counter()
    render(conn, "index.json",pending: pending )
end
def completed_project_count(conn, _params) do
    completed = Projects.all_completed_projects_counter()
    render(conn, "index.json",completed: completed )
end

#All Projects Status Counters
# not started 
def projects_not_started(conn, _params) do
    not_started = Projects.projects_not_started_status()
    render(conn, "index.json", not_started: not_started)
  end
  # planning 
  def projects_planning(conn, _params) do
    planning = Projects.projects_planning_status()
    render(conn, "index.json", planning: planning)
  end
  # under investigation 
  def projects_under_investigation(conn, _params) do
    under_investigation = Projects.projects_investigation_status()
    render(conn, "index.json", under_investigation: under_investigation)
  end
  # on hold
  def projects_hold(conn, _params) do
    on_hold = Projects.projects_hold_status()
    render(conn, "index.json", on_hold: on_hold)
  end
  # in progress
  def projects_in_progress(conn, _params) do
    in_progress = Projects.projects_progress_status()
    render(conn, "index.json", in_progress: in_progress)
  end
  # dev completed
  def projects_dev_complete(conn, _params) do
    dev_complete = Projects.projects_dev_complete_status()
    render(conn, "index.json", dev_complete: dev_complete)
  end
  # QA
  def projects_qa(conn, _params) do
    qa = Projects.projects_qa_status()
    render(conn, "index.json", qa: qa)
  end
  # Deployed
  def projects_deployed(conn, _params) do
    deployed = Projects.projects_deployed_status()
    render(conn, "index.json", deployed: deployed)
  end


#   Project Statuses using categories(  Operational, Strategic)

# not started 
def projects_category_not_started(conn, %{"category_type" => category_type}) do
    not_started = Projects.projects_not_started_status_category_type(category_type)
    render(conn, "index.json", not_started: not_started)
  end
  # planning 
  def projects_category_planning(conn,  %{"category_type" => category_type}) do
    planning = Projects.projects_planning_status_category_type(category_type)
    render(conn, "index.json", planning: planning)
  end
  # under investigation 
  def projects_category_under_investigation(conn,  %{"category_type" => category_type}) do
    under_investigation = Projects.projects_investigation_status_category_type(category_type)
    render(conn, "index.json", under_investigation: under_investigation)
  end
  # on hold
  def projects_category_hold(conn,  %{"category_type" => category_type}) do
    on_hold = Projects.projects_hold_status_category_type(category_type)
    render(conn, "index.json", on_hold: on_hold)
  end
  # in progress
  def projects_category_in_progress(conn,  %{"category_type" => category_type}) do
    in_progress = Projects.projects_progress_status_category_type(category_type)
    render(conn, "index.json", in_progress: in_progress)
  end
  # dev completed
  def projects_category_dev_complete(conn,  %{"category_type" => category_type}) do
    dev_complete = Projects.projects_dev_complete_status_category_type(category_type)
    render(conn, "index.json", dev_complete: dev_complete)
  end
  # QA
  def projects_category_qa(conn,  %{"category_type" => category_type}) do
    qa = Projects.projects_qa_status_category_type(category_type)
    render(conn, "index.json", qa: qa)
  end
  # Deployed
  def projects_category_deployed(conn,  %{"category_type" => category_type}) do
    deployed = Projects.projects_deployed_status_category_type(category_type)
    render(conn, "index.json", deployed: deployed)
  end

################## TEAM COUNTERS #####################


def all_team_projects_count(conn, %{"team_id" => team_id}) do
    counters = Projects.team_projects_counter(team_id)
    render(conn, "index.json", counters: counters)
end
def team_completed_projects(conn, %{"team_id" => team_id}) do
    completed = Projects.team_completed_projects_counter(team_id)
    render(conn, "index.json", completed: completed)
end

def team_pending_projects(conn, %{"team_id" => team_id}) do
    pending = Projects.team_pending_projects_counter(team_id)
    render(conn, "index.json", pending: pending)
end

def all_team_projects_category_count(conn, %{"team_id" => team_id,"category_id" => category_id}) do
  counters = Projects.team_projects_category_counter(team_id,category_id)
  render(conn, "index.json", counters: counters)
end
def team_completed_category_projects(conn, %{"team_id" => team_id,"category_id" => category_id}) do
  completed = Projects.team_completed_projects_category_counter(team_id,category_id)
  render(conn, "index.json", completed: completed)
end

def team_pending_category_projects(conn, %{"team_id" => team_id,"category_id" => category_id}) do
  pending = Projects.team_pending_projects_category_counter(team_id,category_id)
  render(conn, "index.json", pending: pending)
end


#Team Project Statuses using categories( Live Issues, Operational, Strategic)

# not started 
def team_projects_category_not_started(conn, %{"team_id" => team_id,"category_type" => category_type}) do
    not_started = Projects.team_projects_not_started_status_category_type(team_id,category_type)
    render(conn, "index.json", not_started: not_started)
  end
  # planning 
  def team_projects_category_planning(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    planning = Projects.team_projects_planning_status_category_type(team_id,category_type)
    render(conn, "index.json", planning: planning)
  end
  # under investigation 
  def team_projects_category_under_investigation(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    under_investigation = Projects.team_projects_investigation_status_category_type(team_id,category_type)
    render(conn, "index.json", under_investigation: under_investigation)
  end
  # on hold
  def team_projects_category_hold(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    on_hold = Projects.team_projects_hold_status_category_type(team_id,category_type)
    render(conn, "index.json", on_hold: on_hold)
  end
  # in progress
  def team_projects_category_in_progress(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    in_progress = Projects.team_projects_progress_status_category_type(team_id,category_type)
    render(conn, "index.json", in_progress: in_progress)
  end
  # dev completed
  def team_projects_category_dev_complete(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    dev_complete = Projects.team_projects_dev_complete_status_category_type(team_id,category_type)
    render(conn, "index.json", dev_complete: dev_complete)
  end
  # QA
  def team_projects_category_qa(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    qa = Projects.team_projects_qa_status_category_type(team_id,category_type)
    render(conn, "index.json", qa: qa)
  end
  # Deployed
  def team_projects_category_deployed(conn,  %{"team_id" => team_id,"category_type" => category_type}) do
    deployed = Projects.team_projects_deployed_status_category_type(team_id,category_type)
    render(conn, "index.json", deployed: deployed)
  end

  #Team Overview Project Counters
  # not started 
def team_projects_overview_not_started(conn, %{"team_id" => team_id}) do
  not_started = Projects.team_overview_projects_not_started(team_id)
  render(conn, "index.json", not_started: not_started)
end
# planning 
def team_projects_overview_planning(conn,  %{"team_id" => team_id}) do
  planning = Projects.team_overview_projects_planning(team_id)
  render(conn, "index.json", planning: planning)
end
# under investigation 
def team_projects_overview_under_investigation(conn,  %{"team_id" => team_id}) do
  under_investigation = Projects.team_overview_projects_investigation(team_id)
  render(conn, "index.json", under_investigation: under_investigation)
end
# on hold
def team_projects_overview_hold(conn,  %{"team_id" => team_id}) do
  on_hold = Projects.team_overview_projects_hold(team_id)
  render(conn, "index.json", on_hold: on_hold)
end
# in progress
def team_projects_overview_in_progress(conn,  %{"team_id" => team_id}) do
  in_progress = Projects.team_overview_projects_progress(team_id)
  render(conn, "index.json", in_progress: in_progress)
end
# dev completed
def team_projects_overview_dev_complete(conn,  %{"team_id" => team_id}) do
  dev_complete = Projects.team_overview_projects_dev_complete(team_id)
  render(conn, "index.json", dev_complete: dev_complete)
end
# QA
def team_projects_overview_qa(conn,  %{"team_id" => team_id}) do
  qa = Projects.team_overview_projects_qa(team_id)
  render(conn, "index.json", qa: qa)
end
# Deployed
def team_projects_overview_deployed(conn,  %{"team_id" => team_id}) do
  deployed = Projects.team_overview_projects_deployed(team_id)
  render(conn, "index.json", deployed: deployed)
end



############# LIVE ISSUES COUNTER    ################
def active_team_live_issues_counter(conn, %{"team_id" => team_id}) do
  live_issues_counter = Projects.active_team_live_issues(team_id)
  render(conn, "index.json", live_issues_counter: live_issues_counter)
end
def active_live_issues_counter(conn, _params) do
  live_issues_counter = Projects.active_live_issues()
  render(conn, "index.json", live_issues_counter: live_issues_counter)
end

end