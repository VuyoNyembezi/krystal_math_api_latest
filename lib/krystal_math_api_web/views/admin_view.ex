defmodule KrystalMathApiWeb.AdminView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.{ProjectStatusView, PriorityTypeView, ProjectTypeView}
  alias KrystalMathApiWeb.{TaskStatusView, EnvironmentView, TeamView}
  alias KrystalMathApiWeb.{UserView, UserRoleView, UserStatusView, ProjectCategoryTypeView}

  # Enviroment json view

  def render("index.json", %{environments: environments}) do
    %{data: render_many(environments, EnvironmentView, "environment.json")}
  end

  def render("environment.json", %{environment: environment}) do
    %{
      id: environment.id,
      name: environment.name
    }
  end

  def render("show.json", %{environment: environment}) do
    %{data: render_one(environment, EnvironmentView, "environment.json")}
  end

  # User Status
  def render("index.json", %{user_statuses: user_statuses}) do
    %{data: render_many(user_statuses, UserStatusView, "user_status.json")}
  end

  def render("show.json", %{user_status: user_status}) do
    %{data: render_one(user_status, UserStatusView, "user_status.json")}
  end

  def render("user_status.json", %{user_status: user_status}) do
    %{
      id: user_status.id,
      name: user_status.name
    }
  end

  # project type json view
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

  # project category type
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

  #   task status json view
  def render("index.json", %{task_statuses: task_statuses}) do
    %{data: render_many(task_statuses, TaskStatusView, "task_status.json")}
  end

  def render("show.json", %{task_status: task_status}) do
    %{data: render_one(task_status, TaskStatusView, "task_status.json")}
  end

  def render("task_status.json", %{task_status: task_status}) do
    %{
      id: task_status.id,
      name: task_status.name
    }
  end

  # Priority json view

  def render("index.json", %{priority_types: priority_types}) do
    %{data: render_many(priority_types, PriorityTypeView, "priority_type.json")}
  end

  def render("priority_type.json", %{priority_type: priority_type}) do
    %{
      id: priority_type.id,
      name: priority_type.name
    }
  end

  def render("show.json", %{priority_type: priority_type}) do
    %{data: render_one(priority_type, PriorityTypeView, "priority_type.json")}
  end

  # projects Statuses json view

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

  def render("project_status.json", %{project_status: project_status}) do
    %{data: render_one(project_status, ProjectStatusView, "project_status.json")}
  end

  # Role json view
  def render("index.json", %{user_roles: user_roles}) do
    %{data: render_many(user_roles, UserRoleView, "role_members.json")}
  end

  def render("show.json", %{user_role: user_role}) do
    %{data: render_one(user_role, UserRoleView, "role_members.json")}
  end

  def render("show_update.json", %{user_role: user_role}) do
    %{data: render_one(user_role, UserRoleView, "role.json")}
  end

  def render("role_members.json", %{user_role: user_role}) do
    %{
      id: user_role.id,
      name: user_role.name
    }
  end

  def render("role.json", %{user_role: user_role}) do
    %{
      id: user_role.id,
      name: user_role.name
    }
  end

  # User view json files generators

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
      role: render_one(user.role, UserRoleView, "role.json")
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

  # for logging in user
  def render("show_logging.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_logging.json")}
  end

  def render("user_logging.json", %{user: user}) do
    %{
      employee_code: user.employee_code,
      name: user.name,
      team: render_one(user.team, TeamView, "team.json"),
      role: render_one(user.role, UserRoleView, "role.json")
    }
  end

  # display user projects
  def render("show_projects.json", %{user: user}) do
    %{data: render_one(user, UserView, "my_projects.json")}
  end

  def render("my_projects.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      last_name: user.last_name,
      email: user.email,
      team: render_one(user.team, TeamView, "team.json"),
      # # department: render_one(user.department, DepartmentView, "department.json"),
      # environment: render_one(user.environment, environmentView, "environment.json"),
      project: render_many(user.project, ProjectView, "project.json")
    }
  end

  # Team view controller

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
end
