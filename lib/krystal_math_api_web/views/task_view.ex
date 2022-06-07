defmodule KrystalMathApiWeb.TaskView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.{TaskView, TaskStatusView, EnvironmentView, TeamView}
  alias KrystalMathApiWeb.{UserView, UserStatusView,CounterView}

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
      active: task.active,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

  def render("full_task_details.json", %{task: task}) do
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
      active: task.active,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
  def render("task_overview.json", %{task_overview: task_overview}) do
    %{
      all_tasks: render_many( task_overview.all_tasks, TaskView, "full_task_details.json"),
      active_tasks: render_many(task_overview.active_tasks, TaskView, "full_task_details.json"),
      not_active_tasks: render_many(task_overview.not_active_tasks, TaskView, "full_task_details.json"),
       open_tasks: render_many(task_overview.open_tasks, TaskView, "full_task_details.json"),
       over_due_tasks: render_many(task_overview.over_due_tasks, TaskView, "full_task_details.json"),
       completed_tasks: render_many(task_overview.completed_tasks, TaskView, "full_task_details.json")
    }
  end




  # USER JSON VIEW USED FOR ASSOCIATION

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_team.json")}
  end

  # json for active and deactive users display
  def render("user_state.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
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
      password_reset: user.password_reset,
      team: render_one(user.team, TeamView, "team.json")
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

  # TEAM JSON VIEW

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name
    }
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
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

  def render("show_members.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team_members.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      users: render_many(team.users, UserView, "user_details.json")
    }
  end

  # TASK STATUS  JSON VIEW

  def render("index.json", %{task_statuses: task_statuses}) do
    %{data: render_many(task_statuses, TaskStatusView, "task_status.json")}
  end

  def render("show.json", %{task_status: task_status}) do
    %{data: render_one(task_status, TaskStatusView, "task_status.json")}
  end

  def render("task_status.json", %{task_status: task_status}) do
    %{
      id: task_status.id,
      name: task_status.name,
      level: task_status.level
    }
  end

  # environment JSON VIEW

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

  # Team Tasks
  def render("team_tasks.json", %{team_tasks: team_tasks}) do
    %{data: render_many(team_tasks, TaskView, "task_list.json")}
  end

  # User Tasks
  def render("member_tasks.json", %{member_tasks: member_tasks}) do
    %{data: render_many(member_tasks, TaskView, "task_list.json")}
  end

  def render("task_list.json", %{task: task}) do
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
      active: task.active,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

# User Status Json View



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









  ################## Counter json Views  ########################

  def render("index.json", %{tasks_count: tasks_count}) do
    %{
      data: render_many(tasks_count, CounterView, "task_counter.json")
    }
  end
  def render("task_counter.json", %{counter: counter}) do
    %{
      tasks_count: counter.tasks_count
    }
  end
  
# Task status Counter

# not started
def render("index.json", %{task_not_started: task_not_started}) do
  %{
    data: render_many(task_not_started, CounterView, "not_started_tasks.json")
  }
end

def render("not_started_tasks.json", %{counter: counter}) do
  %{
    task_not_started: counter.task_not_started
  }
end

# on hold
def render("index.json", %{task_on_hold: task_on_hold}) do
  %{
    data: render_many(task_on_hold, CounterView, "task_on_hold.json")
  }
end

def render("task_on_hold.json", %{counter: counter}) do
  %{
    task_on_hold: counter.task_on_hold
  }
end
# in progress
def render("index.json", %{task_in_progress: task_in_progress}) do
  %{
    data: render_many(task_in_progress, CounterView, "task_in_progress.json")
  }
end

def render("task_in_progress.json", %{counter: counter}) do
  %{
    task_in_progress: counter.task_in_progress
  }
end
# Testing
def render("index.json", %{task_testing: task_testing}) do
  %{
    data: render_many(task_testing, CounterView, "task_testing.json")
  }
end

def render("task_testing.json", %{counter: counter}) do
  %{
    task_testing: counter.task_testing
  }
end
# Completed
def render("index.json", %{task_completed: task_completed}) do
  %{
    data: render_many(task_completed, CounterView, "task_completed.json")
  }
end

def render("task_completed.json", %{counter: counter}) do
  %{
    task_completed: counter.task_completed
  }
end


# Team Counter JSON View

  def render("task_statuses.json", %{task_statuses: task_statuses}) do
    %{
      not_started: task_statuses.not_started,
      on_hold: task_statuses.on_hold,
      in_progress: task_statuses.in_progress,
      testing: task_statuses.testing,
      completed: task_statuses.completed
    }
  end


  # Team tasks

    def render("tasks_overview.json", %{tasks_overview: tasks_overview}) do
    %{
      all_tasks: tasks_overview.all_tasks,
      over_due: tasks_overview.over_due,
      not_completed: tasks_overview.not_completed,
      completed: tasks_overview.completed
    }
  end










end
