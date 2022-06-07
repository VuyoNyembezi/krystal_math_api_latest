defmodule KrystalMathApi.TaskOperations do

import Ecto.Query, warn: false

alias KrystalMathApi.Repo
alias KrystalMathApi.Operations.Task

@doc """
search team task
"""
def team_task_search(team_id,search_term) do
  search_name = "%#{search_term}%"
      Repo.all(from(t in Task,
      where: like(t.name, ^search_name) and t.team_id == ^team_id))
      |> Repo.preload([:team, :user, :task_status,:environment])
end

@doc """
search dev team task
"""
def user_task_search(team_id, user_id, search_term) do
  search_name = "%#{search_term}%"
      Repo.all(from(t in Task,
      where: like(t.name, ^search_name) and t.team_id == ^team_id and t.user_id == ^user_id))
      |> Repo.preload([:team, :user, :task_status,:environment])
end


   @doc """
  get task by id
  """
  # def get_task!(id), do: Repo.get!(Task, id)

  def get_task!(id) do
    Task
    |> Repo.get!(id)
  end


   @doc """
  gets all tasks
  """
  def list_all_tasks do
    Task
    |> Repo.all()
    |> Repo.preload([:team, :user,:task_status,:environment])
  end

     @doc """
  gets all active tasks
  """
  def active_tasks do
    query = from( u in Task, where: u.active == true)
    Repo.all(query)
    |> Repo.preload([:team, :user, :task_status,:environment])
  end
      @doc """
  gets all not active tasks
  """
  def not_active_tasks do
    query = from( u in Task, where: u.active == false)
    Repo.all(query)
    |> Repo.preload([:team, :user, :task_status,:environment])
  end

  ########### Team Task Methods ############
       @doc """
        gets all user tasks
        """
  def all_team_tasks(team_id) do
    query = from(t in Task, where: t.team_id == ^team_id )
    Repo.all(query)
    |> Repo.preload([:team, :user, :task_status, :environment])
  end
    @doc """
  gets all  active team tasks tasks
  """
   def active_team_tasks(team_id) do
    query = from( u in Task, where: u.active == true and u.team_id == ^team_id)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status,:environment])
  end
  @doc """
  gets all not active team tasks
  """
  def not_active_team_tasks(team_id) do
    query = from( u in Task, where: u.active == false  and u.team_id == ^team_id)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end
  @doc """
  gets all  active and open team  tasks
  """
  def active_open_team_tasks(team_id) do
    query = from u in Task, 
    where:  u.due_date >= ^DateTime.utc_now and u.active == true and u.team_id == ^team_id
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status,:environment])
  end
  @doc """
  gets all active but overdue  user tasks
  """
  def team_over_due_tasks(team_id) do
    query = from t in Task, 
    where: t.due_date <= ^DateTime.utc_now and t.team_id == ^team_id and t.active == true
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

#######   User Task Methods #########

  @doc """
    gets all user tasks
  """
  def user_tasks(team_id,user_id) do
    query = from(t in Task, where: t.user_id == ^user_id and t.team_id == ^team_id)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

 @doc """
  gets all active user tasks
 """

  def user_active_tasks(team_id,user_id) do
    query = from(t in Task, where: t.due_date >= ^DateTime.utc_now and t.user_id == ^user_id and t.team_id == ^team_id  and t.active == true)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

  @doc """
    gets all active but overdue  user tasks
  """

  def user_over_due_tasks(team_id,user_id) do
    query = from(t in Task, where: t.due_date <= ^DateTime.utc_now and t.user_id == ^user_id and t.team_id == ^team_id and t.active == true)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

  @doc """
    gets all completed user tasks
  """
  def user_completed_tasks(team_id, user_id) do
    completed_key = 5
    query = from(t in Task, where: t.user_id == ^user_id and t.team_id == ^team_id and t.active == false and t.task_status_id == ^completed_key )
    Repo.all(query)
    |> Repo.preload([:team, :user, :task_status, :environment])
  end
 @doc """
  gets all not active user tasks
 """

  def user_all_not_active_tasks(team_id,user_id) do
    query = from(t in Task, where: t.user_id == ^user_id and t.team_id == ^team_id and t.active == false)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

 @doc """
  gets all  active user tasks
 """

  def user_all_active_tasks(team_id,user_id) do
    query = from(t in Task, where: t.user_id == ^user_id and t.team_id == ^team_id and t.active == true)
    Repo.all(query)
    |> Repo.preload([:team, :user,:task_status, :environment])
  end

@doc """
    Creae new Task 
"""
  def add_task(attrs \\%{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end
  
    @doc """
    update Task Record 
    """
    def update_task(%Task{} = task, attrs) do
        task
        |> Task.changeset(attrs)
        |> Repo.update()
    end
      
    @doc """
     Dev update Task Record 
    """
    def dev_update_task_values(%Task{} = task, attrs) do
      task
      |> Task.dev_changeset(attrs)
      |> Repo.update()
  end


    @doc """
        deactivate Task Record 
    """
    def deactivate_tasks(%Task{} = task, attrs) do
        task
        |> Task.de_activation_changeset(attrs)
        |> Repo.update()
      end

    @doc """
        activate Task Record 
    """
    def activate_tasks(%Task{} = task, attrs) do
        task
        |> Task.activation_changeset(attrs)
        |> Repo.update()
      end

        @doc """
        deletes the record of the task
        """

        def delete_task({%Task{} = task}) do
            Repo.delete(task)
        end

        @doc """
        returns a `%Ecto.Changeset{}` for tracking task changes.
        """

        def change_task(%Task{} = task, attrs \\ %{}) do
            Task.changeset(task, attrs)
        end

### Counters #

### USER #####
  # overrall task counters 
  def user_completed_tasks_counter(team_id, user_id) do
    completed_key = 5
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id == ^completed_key )
    Repo.one(query)
  end
  def user_not_completed_tasks_counter(team_id, user_id) do
    completed_key = 5
    query = from(t in Task,select: count(t.id), where: t.due_date >= ^DateTime.utc_now and t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id != ^completed_key  and t.active == true)
    Repo.one(query)
  end
  # all user tasks
  def user_tasks_counter(team_id, user_id) do
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id  )
    Repo.one(query)
  end
#  all overdue tasks
  def user_overdue_tasks(team_id, user_id) do
    completed_key = 5 
    query = from(t in Task,select: count(t.id), where: t.due_date <= ^DateTime.utc_now and t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id != ^completed_key and  t.active == true )
    Repo.one(query)
  end 

  ####@@@@ LATEST @@@@############
    # teast tasks statuses
    def user_task_completion(team_id, user_id) do
      user_tasks =  %{completed: user_completed_tasks_counter(team_id, user_id),
      not_completed: user_not_completed_tasks_counter(team_id, user_id),
      over_due: user_overdue_tasks(team_id, user_id),
      all_tasks: user_tasks_counter(team_id, user_id)}
  
      user_tasks
      # |> Repo.one(team_tasks)
      # Repo.load(team_tasks)
      # JSON.encode(team_tasks)
      end



# user task status status counter
def user_tasks_not_started(team_id, user_id) do
    status_key = 1
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id == ^status_key and t.active == true  )
    Repo.one(query)
end
def user_tasks_on_hold(team_id, user_id) do
    status_key = 2
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
end
  
def user_tasks_in_progress(team_id, user_id) do
    status_key = 3
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
end
  
def user_tasks_testing(team_id, user_id) do
    status_key = 4
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id  and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
end
  
def user_tasks_completed(team_id, user_id) do
    status_key = 5
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.user_id == ^user_id  and t.task_status_id == ^status_key )
    Repo.one(query)
end

 ####@@@@ LATEST @@@@############
    # teast tasks statuses
    def user_tasks_statuses(team_id, user_id) do
      user_tasks_status =  %{not_started: user_tasks_not_started(team_id, user_id),
      on_hold: user_tasks_on_hold(team_id, user_id),
      in_progress: user_tasks_in_progress(team_id, user_id),
      testing: user_tasks_testing(team_id, user_id),
      completed: user_tasks_completed(team_id, user_id)}
  
      user_tasks_status
      end






############# TEAM #####
# Team Status Counters
  def team_completed_tasks(team_id) do
      completed_key = 5 
      query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^completed_key  and t.active == true)
      Repo.one(query)
  end
  
  def team_not_completed_tasks(team_id) do
    completed_key = 5 
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id != ^completed_key  and t.active == true)
    Repo.one(query)
  end
  
  def team_overdue_tasks(team_id) do
    completed_key = 5 
    query = from t in Task,select: count(t.id), where: t.due_date <= ^DateTime.utc_now and t.team_id == ^team_id and t.task_status_id != ^completed_key and  t.active == true
    Repo.one(query)
  end
  
  def all_team_tasks_count(team_id) do 
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id  )
    Repo.one(query)
  end

    ####@@@@ LATEST @@@@############
    # teast tasks statuses
  def team_task_completion(team_id) do
    team_tasks =  %{completed: team_completed_tasks(team_id),
    not_completed: team_not_completed_tasks(team_id),
    over_due: team_overdue_tasks(team_id),
    all_tasks: all_team_tasks_count(team_id)}

    team_tasks
  end

##Team Task Status Counters 
  def team_tasks_not_started(team_id) do
    status_key = 1
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
  end

  def team_tasks_on_hold(team_id) do
    status_key = 2
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
  end

  def team_tasks_in_progress(team_id) do
    status_key = 3
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
  end

  def team_tasks_testing(team_id) do
    status_key = 4
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^status_key and t.active == true)
    Repo.one(query)
  end

  def team_tasks_completed(team_id) do
    status_key = 5
    query = from(t in Task,select: count(t.id), where: t.team_id == ^team_id and t.task_status_id == ^status_key )
    Repo.one(query)
  end


  
  ####@@@@ LATEST @@@@############
    # teast tasks statuses
    def team_tasks_statuses(team_id) do
    team_tasks_status =  %{
    not_started: team_tasks_not_started(team_id),
    on_hold: team_tasks_on_hold(team_id),
    in_progress: team_tasks_in_progress(team_id),
    testing: team_tasks_testing(team_id),
    completed: team_tasks_completed(team_id)
  }

    team_tasks_status
    end
end