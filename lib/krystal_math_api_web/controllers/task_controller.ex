defmodule KrystalMathApiWeb.TaskController do
    use KrystalMathApiWeb, :controller
    alias KrystalMathApi.TaskOperations
    alias KrystalMathApi.Operations.Task
    action_fallback KrystalMathApiWeb.FallbackController


# get all tasks
def get_tasks(conn, _params) do
    tasks = TaskOperations.list_all_tasks()
    render(conn, "index.json", tasks: tasks)
end

# get active projects
def get_active_tasks(conn, _params) do
    tasks = TaskOperations.active_tasks()
    render(conn, "index.json", tasks: tasks)
end

# get not active projects
def get_not_active_tasks(conn, _params) do
    tasks = TaskOperations.not_active_tasks()
    render(conn, "index.json", tasks: tasks)
end

##### Team ########

 @doc """
  gets all  team tasks
  """
def get_team_tasks(conn, %{"id" => team_id}) do
    tasks = TaskOperations.all_team_tasks(team_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all active team tasks
  """
  def get_active_team_tasks(conn, %{"id" => team_id}) do
    tasks = TaskOperations.active_team_tasks(team_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all not active team tasks
  """
  def get_not_active_team_tasks(conn, %{"id" => team_id}) do
    tasks = TaskOperations.not_active_team_tasks(team_id)
    render(conn, "index.json", tasks: tasks)
end
 @doc """
  gets all active and vaild and visible to team members tasks
  """
  def open_team_tasks(conn, %{"id" => team_id}) do
    tasks = TaskOperations.active_open_team_tasks(team_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all over-due team tasks
  """
  def over_due_team_tasks(conn, %{"id" => team_id}) do
    tasks = TaskOperations.team_over_due_tasks(team_id)
    render(conn, "index.json", tasks: tasks)
end


##### User/Dev ########
 @doc """
  gets all  user tasks
  """

  def get_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
end
 @doc """
  gets all active and not overdue user tasks
  """
  def get_open_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_active_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all active user tasks 
  """
  def get_active_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_all_active_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all not active user tasks
  """
  def get_not_active_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_all_not_active_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
end

 @doc """
  gets all over-due user tasks
  """
  def over_due_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_over_due_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
  end
 @doc """
  gets all completed user tasks
  """
  def completed_user_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
    tasks = TaskOperations.user_completed_tasks(team_id,user_id)
    render(conn, "index.json", tasks: tasks)
  end


## CREATE ##
 @doc """
  create new Task Record
  """
def create_task(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- TaskOperations.add_task(task_params) do
      conn
      |> put_status(:created)
      |> render("show_new.json", task: task)
    end
end



## UPDATE/ Record Changes ##
  @doc """
  update Task record
  """
  def update_task(conn, %{"id" => id, "task" => task_params}) do
    task = TaskOperations.get_task!(id)
    with {:ok, %Task{} = task} <- TaskOperations.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

   @doc """
    Activate Task Status record
  """
  def activate_task(conn, %{"id" => id, "task" => task_params}) do
    task = TaskOperations.get_task!(id)
    with {:ok, %Task{} = task} <- TaskOperations.activate_tasks(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

   @doc """
  De Activate Task Status record
  """
  def de_activate_task(conn, %{"id" => id, "task" => task_params}) do
    task = TaskOperations.get_task!(id)
    with {:ok, %Task{} = task} <- TaskOperations.deactivate_tasks(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end




### DELETE #######

def delete_task(conn, %{"id" => id}) do
    task = TaskOperations.get_task!(id)
    with {:ok,%Task{} = task} <- TaskOperations.delete_task(task) do
      conn
      |> put_status(200)
      |> text("task deleted")
    end
  end


#######  Counters  #

## User Overview Task Counters ####
def user_completed_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
  tasks_count = TaskOperations.user_completed_tasks_counter(team_id,user_id)
  render(conn, "index.json", tasks_count: tasks_count)
end
# user pending tasks
def user_not_completed_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
  tasks_count = TaskOperations.user_not_completed_tasks_counter(team_id, user_id)
  render(conn, "index.json", tasks_count: tasks_count)
end
# all assigned tasks
def user_all_tasks(conn, %{"team_id" => team_id,"id" => user_id}) do
  tasks_count = TaskOperations.user_tasks_counter(team_id,user_id)
  render(conn, "index.json", tasks_count: tasks_count)
end

def user_tasks_overdue(conn, %{"team_id" => team_id,"id" => user_id}) do
  tasks_count = TaskOperations.user_overdue_tasks(team_id, user_id)
   render(conn, "index.json", tasks_count: tasks_count)
 end
#########  user task status Counters #####

def user_tasks_not_started(conn, %{"team_id" => team_id,"id" => user_id}) do
  task_not_started = TaskOperations.user_tasks_not_started(team_id, user_id)
   render(conn, "index.json", task_not_started: task_not_started)
 end

 def user_tasks_on_hold(conn, %{"team_id" => team_id,"id" => user_id}) do
  task_on_hold = TaskOperations.user_tasks_on_hold(team_id, user_id)
   render(conn, "index.json", task_on_hold: task_on_hold)
 end

 def user_tasks_in_progress(conn, %{"team_id" => team_id,"id" => user_id}) do
  task_in_progress = TaskOperations.user_tasks_in_progress(team_id, user_id)
   render(conn, "index.json", task_in_progress: task_in_progress)
 end

 def user_tasks_testing(conn, %{"team_id" => team_id,"id" => user_id}) do
  task_testing = TaskOperations.user_tasks_testing(team_id, user_id)
   render(conn, "index.json", task_testing: task_testing)
 end

 def user_tasks_completed(conn, %{"team_id" => team_id,"id" => user_id}) do
  task_completed = TaskOperations.user_tasks_completed(team_id, user_id)
   render(conn, "index.json", task_completed: task_completed)
 end

##### Team ######

## Team Overview Task Counters ####
def team_completed_tasks(conn, %{"team_id" => team_id}) do
  tasks_count = TaskOperations.team_completed_tasks(team_id)
  render(conn, "index.json", tasks_count: tasks_count)
end
# Team pending tasks
def team_not_completed_tasks(conn, %{"team_id" => team_id}) do
  tasks_count = TaskOperations.team_not_completed_tasks(team_id)
  render(conn, "index.json", tasks_count: tasks_count)
end
# all team assigned tasks
def team_all_tasks(conn, %{"team_id" => team_id}) do
  tasks_count = TaskOperations.all_team_tasks_count(team_id)
  render(conn, "index.json", tasks_count: tasks_count)
end
# Team over due task
def team_tasks_overdue(conn, %{"team_id" => team_id}) do
  tasks_count = TaskOperations.team_overdue_tasks(team_id)
   render(conn, "index.json", tasks_count: tasks_count)
 end

def get_team_tasks_counter(conn, %{"id" => team_id}) do
    team_tasks = TaskOperations.team_task_completion(team_id)
    render(conn, "team_tasks.json", team_tasks: team_tasks)
end


 ##### team tasks status counter ######

def team_tasks_not_started(conn, %{"id" => team_id}) do
  task_not_started = TaskOperations.team_tasks_not_started(team_id)
   render(conn, "index.json", task_not_started: task_not_started)
 end

 def team_tasks_on_hold(conn, %{"id" => team_id}) do
  task_on_hold = TaskOperations.team_tasks_on_hold(team_id)
   render(conn, "index.json", task_on_hold: task_on_hold)
 end

 def team_tasks_in_progress(conn, %{"id" => team_id}) do
  task_in_progress = TaskOperations.team_tasks_in_progress(team_id)
   render(conn, "index.json", task_in_progress: task_in_progress)
 end

 def team_tasks_testing(conn, %{"id" => team_id}) do
  task_testing = TaskOperations.team_tasks_testing(team_id)
   render(conn, "index.json", task_testing: task_testing)
 end

 def team_tasks_completed(conn, %{"id" => team_id}) do
  task_completed = TaskOperations.team_tasks_completed(team_id)
   render(conn, "index.json", task_completed: task_completed)
 end


def get_team_tasks_status_counter(conn, %{"id" => team_id}) do
    task_statuses = TaskOperations.team_tasks_statuses(team_id)
    render(conn, "team_task_statuses.json", task_statuses: task_statuses)
end




end