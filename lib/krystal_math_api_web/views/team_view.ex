defmodule KrystalMathApiWeb.TeamView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.{TeamView,TaskView}
  alias KrystalMathApiWeb.UserView

  
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

  #User view json files generators

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_team.json")}
  end
  def render("user_with_team.json", %{user: user})do
    %{
       id: user.id,
       employee_code: user.employee_code,
       name: user.name,
       last_name: user.last_name,
       email: user.email,
       team: render_one(user.team, TeamView, "team.json")}
   end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      employee_code: user.employee_code,
      name: user.name,
      last_name: user.last_name,
      email: user.email,
      password: user.password,
      team_id: user.team_id,
      is_active: user.is_active,
      password_reset: user.password_reset
    }
  end


# Task json views
  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "full_task_details.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("show_new.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      name: task.name,
      team_id: task.team_id,
      user_id: task.user_id,
      task_status_id: task.task_status_id,
      environment_id: task.environment_id,
      task_comment: task.task_comment,
      due_date: task.due_date,
      kickoff_date: task.kickoff_date,
      active: task.active
    }
  end

  def render("full_task_details.json" ,%{task: task}) do
    %{
      id: task.id,
      name: task.name,
      team: render_one(task.team, TeamView, "team.json"),
      user: render_one(task.user, UserView, "user.json"),
      task_status: render_one(task.task_status, TaskStatusView, "task_status.json"),
      environment: render_one(task.environment, EnvironmentView, "environment.json"),
      task_comment: task.task_comment,
      due_date: task.due_date,
      kickoff_date: task.kickoff_date,
      active: task.active
    }
  end



end
