defmodule KrystalMathApiWeb.UserView do
  use KrystalMathApiWeb, :view
  # alias KrystalMathApiWeb.UserView
  alias KrystalMathApiWeb.{
    ProjectView,
    UserRoleView,
    EnvironmentView,
    TeamView,
    UserView
  }

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

  # for logging user
  def render("show_logging.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_logging.json")}
  end

  def render("user_logging.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      team: render_one(user.team, TeamView, "team.json"),
      user_role: render_one(user.user_role, UserRoleView, "role.json")
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
    
      # environment: render_one(user.environment, environmentView, "environment.json"),
      project: render_many(user.project, ProjectView, "project.json")
    }
  end

  # view to return code
  def render("code.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_code.json")}
  end

  def render("user_code.json", %{user: user}) do
    %{
      password_reset: user.password_reset
    }
  end

  # view to return access token

  def render("token.json", %{access_token: access_token}) do
    %{
      access_token: access_token,
      status: 201
    }
  end

  # team view controls

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_members.json")}
  end

  def render("team_members.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      user: render_many(team.user, UserView, "user_details.json")
    }
  end

  def render("show_members.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_members.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name
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
      team_id: user.team_id,
      is_admin: user.is_admin
    }
  end

  def render("team_with_leader.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team_team_lead.json")}
  end

  def render("team_team_lead.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      user: render_one(team.user, UserView, "user.json")
    }
  end

  # Project views

  

  # environment view controls

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

  # roles view controls

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
end
