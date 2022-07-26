defmodule KrystalMathApiWeb.AssignmentController do
  use KrystalMathApiWeb, :controller
  alias KrystalMathApi.ProjectAssignments
  alias KrystalMathApi.Projects.ProjectAssignment

  action_fallback KrystalMathApiWeb.FallbackController

  ######### Projects Assignments  ########

  # get all  projects assignments
  def get_project_assignments(conn, _params) do
    projects_assignments = ProjectAssignments.list_assigned_projects()
    render(conn, "index.json", projects_assignments: projects_assignments)
  end

  # get all projects assignments by project type
  def get_project_assignments_project_type(conn, %{"id" => project_type}) do
    projects_assignment = ProjectAssignments.all_projects_assignments_project_type(project_type)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  ######### Search Methods #########
  # serach team projects assignments 
  # def team_project_assignments_search(conn, %{"team_id" => team_id,"project_type" => project_type,"search" => search_term}) do
  #   projects_assignment = ProjectAssignments.team_project_assignment_search(team_id,project_type,search_term)
  #   render(conn, "assignment_record.json",  projects_assignment: projects_assignment  )
  # end

  def team_search_assignment(conn, %{"team_id" => team_id, "search" => search_term}) do
    projects_assignment = ProjectAssignments.team_search_assignment(team_id, search_term)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # serach team memebr projects assignments 
  # def user_project_assignments_search(conn, %{"team_id" => team_id,"project_type" => project_type,"user_id" => user_id,"search" => search_term}) do
  #   projects_assignment = ProjectAssignments.user_project_assignment_search(team_id,user_id,project_type,search_term)
  #   render(conn, "assignment_record.json",  projects_assignment: projects_assignment  )
  # end
  def user_project_assignments_search(conn, %{
        "team_id" => team_id,
        "user_id" => user_id,
        "search" => search_term
      }) do
    projects_assignment = ProjectAssignments.user_search_assignment(team_id, user_id, search_term)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  ###  Team AssignProject ####

  # get all team projects assignments by project type
  def get_team_project_assignments_project_type(conn, %{
        "team_id" => team_id,
        "id" => project_type
      }) do
    projects_assignment = ProjectAssignments.get_project_assigned_type(team_id, project_type)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get team project assignments
  def get_project_assigned_team(conn, %{"id" => team_id}) do
    projects_assignment = ProjectAssignments.all_projects_assignment_to_team(team_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get over due team project assignments
  def get_over_due_project_assigned_team(conn, %{"id" => team_id}) do
    projects_assignment = ProjectAssignments.all_over_due_projects_assignment_to_team(team_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get team project with members assigned members
  def get_project_assigned_details(conn, %{"team_id" => team_id, "id" => project_id}) do
    projects_assignment = ProjectAssignments.get_project_assigned_details(team_id, project_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # map request for Team assignments Projects
  def overview_project_team_assigned(conn, %{"team_id" => team_id}) do
    assignment = ProjectAssignments.team_project_assignments(team_id)
    render(conn, "project_assignment.json", assignment: assignment)
  end

  # map request for Over Due  Team assignments Projects
  def overview_over_due_project_team_assigned(conn, %{"team_id" => team_id}) do
    assignment = ProjectAssignments.team_over_due_project_assignments(team_id)
    render(conn, "project_assignment.json", assignment: assignment)
  end

  #### Dev/User Assignments ############

  # get member assignments
  def get_project_assigned_member(conn, %{"id" => user_id}) do
    projects_assignment = ProjectAssignments.all_projects_assignment_to_member(user_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get project with members assigned members within a team
  def get_project_dev_assigned(conn, %{"team_id" => team_id, "id" => user_id}) do
    projects_assignment = ProjectAssignments.get_dev_assigned_projects(team_id, user_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get project with members assigned members within a team
  def get_over_due_project_dev_assigned(conn, %{"team_id" => team_id, "id" => user_id}) do
    projects_assignment = ProjectAssignments.get_over_due_dev_assigned_projects(team_id, user_id)
    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get project assignments by team , project type and user identification

  def project_user_assigned(conn, %{
        "team_id" => team_id,
        "project_type" => project_type,
        "id" => user_id
      }) do
    projects_assignment =
      ProjectAssignments.project_type_dev_assigned(team_id, project_type, user_id)

    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  # get over due project assignments by team , project type and user identification

  def over_due_project_user_assigned(conn, %{
        "team_id" => team_id,
        "project_type" => project_type,
        "id" => user_id
      }) do
    projects_assignment =
      ProjectAssignments.over_due_project_type_dev_assigned(team_id, project_type, user_id)

    render(conn, "assignment_record.json", projects_assignment: projects_assignment)
  end

  ### @@@ LATEST @@@#####

  # map request for Dev assignments Projects
  def overview_project_dev_assigned(conn, %{"team_id" => team_id, "id" => user_id}) do
    assignment = ProjectAssignments.dev_project_assignments(team_id, user_id)
    render(conn, "project_assignment.json", assignment: assignment)
  end

  # map request for Over Due Dev assignments Projects
  def overview_over_due_project_dev_assigned(conn, %{"team_id" => team_id, "id" => user_id}) do
    assignment = ProjectAssignments.dev_over_due_project_assignments(team_id, user_id)
    render(conn, "project_assignment.json", assignment: assignment)
  end

  # # Create Assignment
  def assign_project(conn, %{"projects_assignment" => project_assignment_params}) do
    with {:ok, %ProjectAssignment{} = projects_assignment} <-
           ProjectAssignments.create_project_assignment(project_assignment_params) do
      conn
      |> put_status(:created)
      |> text("new member assigned to the project")
      |> render(conn, "show.json", projects_assignment: projects_assignment)
    end
  end

  # update  assignment Details for Bet projects 
  def update_assignment_details(conn, %{
        "id" => id,
        "projects_assignment" => project_assignment_params
      }) do
    projects_assignment = ProjectAssignments.get_assignment_project!(id)

    with {:ok, %ProjectAssignment{} = projects_assignment} <-
           ProjectAssignments.update_project_assign(
             projects_assignment,
             project_assignment_params
           ) do
      conn
      |> put_status(200)
      |> render("show.json", projects_assignment: projects_assignment)
    end
  end

  # delete assignement Record/ removes assignment record from the system

  def un_assign_member(conn, %{"id" => id}) do
    projects_assignment = ProjectAssignments.get_assignment_project!(id)

    with {:ok, %ProjectAssignment{} = projects_assignment} <-
           ProjectAssignments.delete_assign_member(projects_assignment) do
      conn
      |> put_status(200)
      |> text("member removed from project")
    end
  end

  ####### Counters ############

  # get user projects assignments  overview count
  def user_project_assignment(conn, %{
        "team_id" => team_id,
        "category_id" => category_id,
        "user_id" => user_id
      }) do
    assignment_overview = ProjectAssignments.user_assignment(team_id, category_id, user_id)
    render(conn, "assignment_status_overview.json", assignment_overview: assignment_overview)
  end

  # get user operational projects assignments  overview count
  def user_operational_project_assignment(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    assignment_overview = ProjectAssignments.user_operational_assignment(team_id, user_id)
    render(conn, "assignment_status_overview.json", assignment_overview: assignment_overview)
  end

  # get user strategic projects assignments  overview count
  def user_strategic_project_assignment(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    assignment_overview = ProjectAssignments.user_strategic_assignment(team_id, user_id)
    render(conn, "assignment_status_overview.json", assignment_overview: assignment_overview)
  end
end
