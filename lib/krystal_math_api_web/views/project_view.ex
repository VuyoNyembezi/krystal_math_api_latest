defmodule KrystalMathApiWeb.ProjectView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.{ProjectView, ProjectStatusView, PriorityTypeView}
  alias KrystalMathApiWeb.{UserView, ProjectTypeView, CounterView}
  alias KrystalMathApiWeb.{TeamView, ProjectCategoryTypeView, LiveIssueView}

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project_details.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project_details.json")}
  end

  def render("project.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      business_request_document_status: project.business_request_document_status,
      business_request_document_link: project.business_request_document_link,
      project_status_id: project.project_status_id,
      user_id: project.user_id,
      team_id: project.team_id,
      project_type_id: project.project_type_id,
      project_category_type_id: project.project_category_type_id,
      last_status_change: project.last_status_change,
      priority_type_id: project.priority_type_id,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end

  def render("project_details.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      business_request_document_status: project.business_request_document_status,
      business_request_document_link: project.business_request_document_link,
      last_status_change: project.last_status_change,
      project_status:
        render_one(project.project_status, ProjectStatusView, "project_status.json"),
      user: render_one(project.user, UserView, "user.json"),
      team: render_one(project.team, TeamView, "team.json"),
      project_type: render_one(project.project_type, ProjectTypeView, "project_type.json"),
      project_category_type:
        render_one(
          project.project_category_type,
          ProjectCategoryTypeView,
          "project_category.json"
        ),
      priority_type: render_one(project.priority_type, PriorityTypeView, "priority_type.json"),
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end

  def render("project_overview.json", %{project: project}) do
    %{
      bet_projects: render_many(project.bet_projects, ProjectView, "project_details.json"),
      country_projects:
        render_many(project.country_projects, ProjectView, "project_details.json"),
      customer_journey_projects:
        render_many(project.customer_journey_projects, ProjectView, "project_details.json"),
      integrations_projects:
        render_many(project.integrations_projects, ProjectView, "project_details.json"),
      payment_method_projects:
        render_many(project.payment_method_projects, ProjectView, "project_details.json"),
      digital_marketing_projects:
        render_many(project.digital_marketing_projects, ProjectView, "project_details.json"),
      bet_project_partners_projects:
        render_many(project.bet_project_partners_projects, ProjectView, "project_details.json"),
      all_projects: render_many(project.all_projects, ProjectView, "project_details.json")
    }
  end

  # Priority View

  def render("index.json", %{priority_types: priority_types}) do
    %{data: render_many(priority_types, PriorityTypeView, "priority_type.json")}
  end

  def render("priority_type.json", %{priority_type: priority_type}) do
    %{
      id: priority_type.id,
      name: priority_type.name,
      level: priority_type.level
    }
  end

  def render("show.json", %{priority_type: priority_type}) do
    %{data: render_one(priority_type, PriorityTypeView, "priority_type.json")}
  end

  # Project Status View

  def render("index.json", %{project_statuses: project_statuses}) do
    %{data: render_many(project_statuses, ProjectStatusView, "project_status.json")}
  end

  def render("project_status.json", %{project_status: project_status}) do
    %{
      id: project_status.id,
      name: project_status.name,
      effect: project_status.effect,
      level: project_status.level
    }
  end

  def render("show.json", %{project_status: project_status}) do
    %{data: render_one(project_status, ProjectStatusView, "project_status.json")}
  end

  # Project Type View
  def render("index.json", %{project_types: project_types}) do
    %{data: render_many(project_types, ProjectTypeView, "project_type.json")}
  end

  def render("project_type.json", %{project_type: project_type}) do
    %{
      id: project_type.id,
      name: project_type.name
    }
  end

  def render("show.json", %{project_type: project_type}) do
    %{data: render_one(project_type, ProjectTypeView, "project_type.json")}
  end

  # Team View  

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("team_with_leader.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team_team_lead.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_members.json")}
  end

  def render("show_members.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_members.json")}
  end

  def render("team_members.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      is_active: team.is_active,
      users: render_many(team.users, UserView, "user_details.json")
    }
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      team_lead_id: team.team_lead_id,
      is_active: team.is_active
    }
  end

  def render("team_team_lead.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      team_lead: render_one(team.team_lead, UserView, "user.json"),
      is_active: team.is_active
    }
  end

  def render("user_details.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      last_name: user.last_name,
      is_active: user.is_active,
      email: user.email,
      is_admin: user.is_admin
    }
  end

  # Project Category Type View
  def render("index.json", %{project_categories: project_categories}) do
    %{data: render_many(project_categories, ProjectCategoryTypeView, "project_category.json")}
  end

  def render("project_category.json", %{project_category_type: project_category_type}) do
    %{
      id: project_category_type.id,
      name: project_category_type.name
    }
  end

  def render("show.json", %{project_category_type: project_category_type}) do
    %{data: render_one(project_category_type, ProjectCategoryTypeView, "project_category.json")}
  end

  # User View
  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_team.json")}
  end

  # json for active and deactive users display
  def render("user_state.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  # new registered user
  def render("show_new.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  # display user with team details

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_team.json")}
  end

  def render("user_with_team.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      last_name: user.last_name,
      email: user.email,
      password: user.password,
      password_reset: user.password_reset,
      is_admin: user.is_admin,
      team: render_one(user.team, TeamView, "team.json"),
      user_role: render_one(user.user_role, UserRoleView, "role.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      last_name: user.last_name,
      password: user.password,
      team_id: user.team_id,
      is_active: user.is_active,
      password_reset: user.password_reset,
      email: user.email,
      is_admin: user.is_admin
    }
  end

  # Live Issues View
  def render("index.json", %{live_issues: live_issues}) do
    %{data: render_many(live_issues, LiveIssueView, "live_issue_details.json")}
  end

  def render("show.json", %{live_issue: live_issue}) do
    %{data: render_one(live_issue, LiveIssueView, "live_issue_details.json")}
  end

  def render("live_issue.json", %{live_issue: live_issue}) do
    %{
      id: live_issue.id,
      name: live_issue.name,
      business_request_document_status: live_issue.business_request_document_status,
      business_request_document_link: live_issue.business_request_document_link,
      project_status_id: live_issue.project_status_id,
      assigned_date: live_issue.assigned_date,
      pm_id: live_issue.pm_id,
      team_id: live_issue.team_id,
      last_status_change: live_issue.last_status_change,
      priority_type_id: live_issue.priority_type_id,
      is_active: live_issue.is_active,
      inserted_at: live_issue.inserted_at,
      updated_at: live_issue.updated_at
    }
  end

  def render("live_issue_details.json", %{live_issue: live_issue}) do
    %{
      id: live_issue.id,
      name: live_issue.name,
      business_request_document_status: live_issue.business_request_document_status,
      business_request_document_link: live_issue.business_request_document_link,
      last_status_change: live_issue.last_status_change,
      assigned_date: live_issue.assigned_date,
      project_status:
        render_one(live_issue.project_status, ProjectStatusView, "project_status.json"),
      user: render_one(live_issue.user, UserView, "user.json"),
      team: render_one(live_issue.team, TeamView, "team.json"),
      priority_type: render_one(live_issue.priority_type, PriorityTypeView, "priority_type.json"),
      is_active: live_issue.is_active,
      inserted_at: live_issue.inserted_at,
      updated_at: live_issue.updated_at
    }
  end

  def render("live_overview.json", %{live_issue: live_issue}) do
    %{
      all_live_issues:
        render_many(live_issue.all_live_issues, LiveIssueView, "live_issue_details.json"),
      active_live_issues:
        render_many(live_issue.active_live_issues, LiveIssueView, "live_issue_details.json"),
      not_active_live_issues:
        render_many(live_issue.not_active_live_issues, LiveIssueView, "live_issue_details.json"),
      completed_live_issues:
        render_many(live_issue.completed_live_issues, LiveIssueView, "live_issue_details.json")
    }
  end

  # Project Counter View
  def render("index.json", %{counters: counters}) do
    %{
      data: render_many(counters, CounterView, "counter_details.json")
    }
  end

  def render("counter_details.json", %{counter: counter}) do
    %{
      projects_count: counter.projects_count
    }
  end

  # Project Completion Status Counters

  #  Completed Project counter views
  def render("index.json", %{completed: completed}) do
    %{
      data: render_many(completed, CounterView, "completed_counter_details.json")
    }
  end

  def render("completed_counter_details.json", %{counter: counter}) do
    %{
      completed_projects: counter.completed_projects
    }
  end

  #  Pending Project counter views
  def render("index.json", %{pending: pending}) do
    %{
      data: render_many(pending, CounterView, "pending_counter_details.json")
    }
  end

  def render("pending_counter_details.json", %{counter: counter}) do
    %{
      pending_projects: counter.pending_projects
    }
  end

  #  Not Assigned Project counter views
  def render("index.json", %{not_assigned: not_assigned}) do
    %{
      data: render_many(not_assigned, CounterView, "not_assigned_counter_details.json")
    }
  end

  def render("not_assigned_counter_details.json", %{counter: counter}) do
    %{
      not_assigned_projects: counter.not_assigned_projects
    }
  end

  # Assigned Project counter views
  def render("index.json", %{assigned: assigned}) do
    %{
      data: render_many(assigned, CounterView, "assigned_counter_details.json")
    }
  end

  def render("assigned_counter_details.json", %{counter: counter}) do
    %{
      assigned_projects_count: counter.assigned_projects_count
    }
  end

  # PROJECT STATUS COUNTERS  ####
  # not started counter view
  def render("index.json", %{not_started: not_started}) do
    %{
      data: render_many(not_started, CounterView, "not_started.json")
    }
  end

  def render("not_started.json", %{counter: counter}) do
    %{
      not_started: counter.not_started
    }
  end

  # planning
  def render("index.json", %{planning: planning}) do
    %{
      data: render_many(planning, CounterView, "planning.json")
    }
  end

  def render("planning.json", %{counter: counter}) do
    %{
      planning: counter.planning
    }
  end

  # under investigation
  def render("index.json", %{under_investigation: under_investigation}) do
    %{
      data: render_many(under_investigation, CounterView, "under_investigation.json")
    }
  end

  def render("under_investigation.json", %{counter: counter}) do
    %{
      under_investigation: counter.under_investigation
    }
  end

  # on hold
  def render("index.json", %{on_hold: on_hold}) do
    %{
      data: render_many(on_hold, CounterView, "on_hold.json")
    }
  end

  def render("on_hold.json", %{counter: counter}) do
    %{
      on_hold: counter.on_hold
    }
  end

  # in progress
  def render("index.json", %{in_progress: in_progress}) do
    %{
      data: render_many(in_progress, CounterView, "in_progress.json")
    }
  end

  def render("in_progress.json", %{counter: counter}) do
    %{
      in_progress: counter.in_progress
    }
  end

  # dev complete
  def render("index.json", %{dev_complete: dev_complete}) do
    %{
      data: render_many(dev_complete, CounterView, "dev_complete.json")
    }
  end

  def render("dev_complete.json", %{counter: counter}) do
    %{
      dev_complete: counter.dev_complete
    }
  end

  # qa
  def render("index.json", %{qa: qa}) do
    %{
      data: render_many(qa, CounterView, "qa.json")
    }
  end

  def render("qa.json", %{counter: counter}) do
    %{
      qa: counter.qa
    }
  end

  # deployed
  def render("index.json", %{deployed: deployed}) do
    %{
      data: render_many(deployed, CounterView, "deployed.json")
    }
  end

  def render("deployed.json", %{counter: counter}) do
    %{
      deployed: counter.deployed
    }
  end

  # Maps Counter Views

  def render("project_overview.json", %{project_overview: project_overview}) do
    %{
      all_project: project_overview.all_project,
      pending: project_overview.pending,
      completed: project_overview.completed
    }
  end



  def render("full_project_overview.json", %{project_overview: project_overview}) do
    %{
      all_project: project_overview.all_project,
      pending: project_overview.pending,
      completed: project_overview.completed,
      not_assigned: project_overview.not_assigned,
      assigned: project_overview.assigned
    }
  end

  def render("project_statuses.json", %{project_statsuses: project_statsuses}) do
    %{
      not_started: project_statsuses.not_started,
      planning: project_statsuses.planning,
      under_investigation: project_statsuses.under_investigation,
      on_hold: project_statsuses.on_hold,
      in_progress: project_statsuses.in_progress,
      dev_complete: project_statsuses.dev_complete,
      qa: project_statsuses.qa,
      deployed: project_statsuses.deployed
    }
  end

  def render("projects_overview.json", %{project_statsuses: project_statsuses}) do
    %{
      operational: project_statsuses.operational,
      strategic: project_statsuses.strategic
    }
  end

  def render("projects_counter.json", %{project_count: project_count}) do
    %{
      operational: project_count.operational,
      strategic: project_count.strategic,
      live_issues: project_count.live_issues
    }
  end

  ############# LIVE ISSUES COUNTER VIEW 
  def render("index.json", %{live_issues_counter: live_issues_counter}) do
    %{
      data: render_many(live_issues_counter, CounterView, "live_issues_counter.json")
    }
  end

  def render("live_issues_counter.json", %{counter: counter}) do
    %{
      live_issues_counter: counter.live_issues_counter
    }
  end
end
