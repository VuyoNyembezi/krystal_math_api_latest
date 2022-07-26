defmodule KrystalMathApiWeb.TaskController do
  use KrystalMathApiWeb, :controller
  alias KrystalMathApi.TaskOperations
  alias KrystalMathApi.Operations.Task
  action_fallback KrystalMathApiWeb.FallbackController

  # Search Team Tasks 
  def team_tasks_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    tasks = TaskOperations.team_task_search(team_id, search_term)
    render(conn, "index.json", tasks: tasks)
  end

  # Search User Tasks 
  def user_tasks_search(conn, %{
        "team_id" => team_id,
        "user_id" => user_id,
        "search" => search_term
      }) do
    tasks = TaskOperations.user_task_search(team_id, user_id, search_term)
    render(conn, "index.json", tasks: tasks)
  end

  # Team Search Project Map(Overdue , Active, Not Active, Completed , All)

  def team_search_tasks(conn, %{"team_id" => team_id, "search" => search_term}) do
    task_overview = TaskOperations.team_search(team_id, search_term)
    render(conn, "task_overview.json", task_overview: task_overview)
  end

  # User Search Project Map(Overdue , Active, Not Active, Completed , All)

  def user_search_tasks(conn, %{
        "team_id" => team_id,
        "user_id" => user_id,
        "search" => search_term
      }) do
    task_overview = TaskOperations.team_user_task_search(team_id, user_id, search_term)
    render(conn, "task_overview.json", task_overview: task_overview)
  end

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
  team tasks Map (over_due tasks,open tasks, all tasks, active tasks, not active tasks)
  """

  def team_tasks(conn, %{"id" => team_id}) do
    task_overview = TaskOperations.team_tasks(team_id)
    render(conn, "task_overview.json", task_overview: task_overview)
  end

  ##### User/Dev ########
  @doc """
  user tasks Map (over_due tasks,open tasks, all tasks, active tasks, not active tasks)
  """

  def map_user_tasks(conn, %{"id" => team_id, "user_id" => user_id}) do
    task_overview = TaskOperations.user_tasks_overview(team_id, user_id)
    render(conn, "task_overview.json", task_overview: task_overview)
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
  update Dev Task record
  """
  def dev_update_task(conn, %{"id" => id, "task" => task_params}) do
    task = TaskOperations.get_task!(id)

    with {:ok, %Task{} = task} <- TaskOperations.dev_update_task_values(task, task_params) do
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

    with {:ok, %Task{} = task} <- TaskOperations.delete_task(task) do
      conn
      |> put_status(200)
      |> text("task deleted")
    end
  end

  #######  Counters  #

  ## User Overview Task Counters ####

  # @@@@ LATEST FEATURE ####

  def user_tasks_counter(conn, %{"team_id" => team_id, "id" => user_id}) do
    tasks_overview = TaskOperations.user_task_completion(team_id, user_id)
    render(conn, "tasks_overview.json", tasks_overview: tasks_overview)
  end

  #########  user task status Counters #####

  # @@@@ LATEST FEATURE ####
  def user_tasks_status_counter(conn, %{"team_id" => team_id, "id" => user_id}) do
    task_statuses = TaskOperations.user_tasks_statuses(team_id, user_id)
    render(conn, "task_statuses.json", task_statuses: task_statuses)
  end

  ##### Team ######

  # @@@@ LATEST FEATURE ####

  def get_team_tasks_counter(conn, %{"id" => team_id}) do
    tasks_overview = TaskOperations.team_task_completion(team_id)
    render(conn, "tasks_overview.json", tasks_overview: tasks_overview)
  end

  ##### team tasks status counter ######

  # @@@@ LATEST FEATURE ####
  def get_team_tasks_status_counter(conn, %{"id" => team_id}) do
    task_statuses = TaskOperations.team_tasks_statuses(team_id)
    render(conn, "task_statuses.json", task_statuses: task_statuses)
  end
end
