defmodule KrystalMathApiWeb.CounterView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.CounterView
  
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








###  Task Counters #################



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



# Task status Counters


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
