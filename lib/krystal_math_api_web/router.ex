defmodule KrystalMathApiWeb.Router do
  use KrystalMathApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
  pipeline :auth do
    plug KrystalMathApi.Accounts.Authentication.Pipeline
  end


  scope "/api", KrystalMathApiWeb do
    pipe_through :api
   # ################# USER CONTROLLER ROUTES #################
   
    # initial  routes (only runs when default admin profile is created)
    get "/user/admin/new", UserController, :admin_initial_get
    
    get "/user/code", UserController, :get_reset_key
    get "/user/role", UserController, :user_employee_code


  # Login and Sign up
    post "/user/register", UserController, :signup
    post "/user/signin", UserController, :signin
    post "/user/admin", UserController, :admin_login
  
  # change password and password reset generator routes
       put "/user/resetkey", UserController, :reset_key
       put "/user/passwordreset", UserController, :password_update
  
  # new default credetials update
     put "/user/admin/new_user_update", UserController, :admin_password_initial_update
   
  end

  scope "/api/auth", KrystalMathApiWeb do
    pipe_through [:api, :auth]
######################  ADMIN CONTROLLER ####################
    # USER ROLES ##
    get "/user/roles", AdminController, :all_user_roles
    post "/user/create/role", AdminController, :create_role
    put "/user/role/update", AdminController, :update_user_role
    delete "/user/role/delete", AdminController, :delete_user_role

    ### Enviroments ######
    get "/environments", AdminController, :get_environments
    put "/update/environment", AdminController, :update_environment
    post "/create/environment", AdminController, :create_environment
    delete "/delete/environment", AdminController, :delete_enviroment

    #### Teams ####
    get "/teams", AdminController, :get_teams
    get "/active/teams", AdminController, :get_active_teams
    get "/not_active/teams", AdminController, :get_not_active_teams
    put "/update/team", AdminController, :update_team_info
    put "/deactivate/team", AdminController, :deactivate_team
    put "/activate/team", AdminController, :activate_team
    post "/create/team", AdminController, :create_team
    delete "/delete/team", AdminController, :delete_team

    ##### Task Status #######
    get "/task_statuses", AdminController, :get_task_status
    put "/update/task_status", AdminController, :update_task_status
    post "/create/task_status", AdminController, :create_task_status
    delete "/delete/task_status", AdminController, :delete_task_status

    ##### User Status ####
    get "/user_status/all", AdminController, :get_user_statuses
    put "/user_status/update", AdminController, :update_user_status
    post "/create/user_status", AdminController, :create_user_status 
    delete "/delete/user_status", AdminController, :delete_user_status

    #### Project Status #####
    get "/project_status/all", AdminController, :get_project_statuses
    put "/project_status/update", AdminController, :update_project_status
    post "/project_status/create", AdminController, :create_project_status
    delete "/project_status/delete", AdminController, :delete_project_status

    #### Project Type ####
    get "/project_type/all", AdminController, :get_project_types
    put "/project_type/update", AdminController, :update_project_type
    post "/project_type/create", AdminController, :create_project_type
    delete "/project_type/delete", AdminController, :delete_project_type

    #### Priority Type #####
    get "/priority_type/all", AdminController, :get_priorities
    post "/priority_type/create", AdminController, :create_priority
    put "/priority_type/update", AdminController, :update_priority
    delete "/priority_type/delete", AdminController, :delete_priority_type

    ### Project Category Type

    get "/project_category_type/all", AdminController, :get_project_category_types
    put "/project_category_type/update", AdminController, :update_project_category_type
    post "/project_category_type/create", AdminController, :create_project_category_type
    delete "/project_category_type/delete", AdminController, :delete_project_category_type


################## USER CONTROLLER ##############

    get "/team/members", UserController, :teams_members
    get "/users", UserController, :all_users
    get "/user/role", UserController, :user_by_role
    get "/users/active", UserController, :active_users
    get "/user/byempcode", UserController, :get_user_by_employee_code
    get "/users/terminated", UserController, :terminated_users

    get "/user/projects", UserController, :user_projects
    
    # for user controller
    put "/user/update", UserController, :update_user_details
    put "/user/map", UserController, :mapping_user
    put "/user/terminate", UserController, :terminate_user
    put "/user/activate", UserController, :activate_user
    delete "/user/delete", UserController, :delete_user
    # Log out
    post "/user/logout", UserController, :logout


################ Project Controller ###########
    get "/projects/all", ProjectController, :all_projects
    get "/project", ProjectController, :project_by_id

    # Search
    get "/projects/search", ProjectController, :all_projects_search
    get "/projects/category/search", ProjectController, :projects_category_search
    get "/projects/project_type/search", ProjectController, :projects_type_search
    # team search
    get "/projects/team/all/search", ProjectController, :all_team_projects_search
    get "/projects/team/category/search", ProjectController, :team_projects_category_search
    get "/projects/team/project_type/search", ProjectController, :team_projects_type_search

    get "/projects/operational/all", ProjectController, :all_operational_projects
    get "/projects/strategic/all", ProjectController, :all_strategic_projects
   
    get "/projects/operational/un_assigned/all", ProjectController, :all_un_assigned_operational_projects
    get "/projects/strategic/un_assigned/all", ProjectController, :all_un_assigned_strategic_projects

    # Get Projects Using Project Types
    get "/projects/operational/project_types/all", ProjectController, :all_operational_projects_types
    get "/projects/strategic/project_types/all", ProjectController, :all_strategic_projects_types
    

    # Team Routes 
    get "/team/projects/all", ProjectController, :team_projects
    get "/team/projects/category_type/all", ProjectController, :team_projects_by_category
    get "/team/projects/project_type/all", ProjectController, :team_projects_type
    get "/team/projects/category_and_project_type/all", ProjectController, :team_projects_by_type_and_category
      
    get "/team/projects/project_type/operational/all", ProjectController, :team_operational_project_types
    get "/team/projects/project_type/strategic/all", ProjectController, :team_strategic_project_types

      
    # Create Project
    post "/create/project", ProjectController, :create_new_project
    put "/update/project", ProjectController, :update_project

      ####### Live Issues #############

      # search
      get "/live_issues/all/search", ProjectController, :live_issuses_search
      get "/live_issues/team/search", ProjectController, :team_live_issuses_search

      get "/live_issues/all", ProjectController, :get_live_issuses
      get "/live_issues/status/all", ProjectController, :get_live_issues_status
      # team
      get "/team/live_issues/all", ProjectController, :get_all_team_live_issuses
      get "/team/live_issues/status/all", ProjectController, :get_all_team_live_issuses_status
      get "/team/live_issues/active/all", ProjectController, :get_active_team_live_issuses
      get "/team/live_issues/not_active/all", ProjectController, :get_not_active_team_live_issuses
      get "/team/live_issues/completed/all", ProjectController, :get_completed_team_live_issuses
        # Create live issue
    post "/create/live_issues", ProjectController, :create_new_live_issue
    # update live issue
    put "/live_issue/main/update", ProjectController, :update_live_issue
    put "/live_issue/update", ProjectController, :update_live_issue_status
    # delete live isse
    delete "/live_issue/delete", ProjectController, :delete_live_issue 

    ##### COUNTERS  ###########
    get "/projects/count", ProjectController, :project_count
 
    get "/projects/count/category", ProjectController, :project_count_by_category

    get "/projects/assigned/count/all", ProjectController, :assigned_project_count
    get "/projects/not_assigned/count/all", ProjectController, :not_assigned_project_count
    # project completion status
    get "/projects/pending/count/all", ProjectController, :pending_project_count
    get "/projects/completed/count/all", ProjectController, :completed_project_count
    # project status counters
    get "/projects/count/not_started", ProjectController, :projects_not_started
    get "/projects/count/planning", ProjectController, :projects_planning
    get "/projects/count/under_investigation", ProjectController, :projects_under_investigation
    get "/projects/count/on_hold", ProjectController, :projects_hold
    get "/projects/count/in_progress", ProjectController, :projects_in_progress
    get "/projects/count/dev_complete", ProjectController, :projects_dev_complete
    get "/projects/count/qa", ProjectController, :projects_qa
    get "/projects/count/deployed", ProjectController, :projects_deployed

    # project status counters by category ( Operational, Strategic)
    get "/projects/category/count/not_started", ProjectController, :projects_category_not_started
    get "/projects/category/count/planning", ProjectController, :projects_category_planning
    get "/projects/category/count/under_investigation", ProjectController, :projects_category_under_investigation
    get "/projects/category/count/on_hold", ProjectController, :projects_category_hold
    get "/projects/category/count/in_progress", ProjectController, :projects_category_in_progress
    get "/projects/category/count/dev_complete", ProjectController, :projects_category_dev_complete
    get "/projects/category/count/qa", ProjectController, :projects_category_qa
    get "/projects/category/count/deployed", ProjectController, :projects_category_deployed

    #Team Project Counters 
    get "/team/project/count/all", ProjectController, :all_team_projects_count
    get "/team/project/count/complete", ProjectController, :team_completed_projects
    get "/team/project/count/pending", ProjectController, :team_pending_projects

    # by category Team Projects
    get "/team/project/category/count/all", ProjectController, :all_team_projects_category_count
    get "/team/project/category/count/complete", ProjectController, :team_completed_category_projects
    get "/team/project/category/count/pending", ProjectController, :team_pending_category_projects

    # team project status counters by category (, Operational, Strategic)
    get "/team_projects/category/count/not_started", ProjectController, :team_projects_category_not_started
    get "/team_projects/category/count/planning", ProjectController, :team_projects_category_planning
    get "/team_projects/category/count/under_investigation", ProjectController, :team_projects_category_under_investigation
    get "/team_projects/category/count/on_hold", ProjectController, :team_projects_category_hold
    get "/team_projects/category/count/in_progress", ProjectController, :team_projects_category_in_progress
    get "/team_projects/category/count/dev_complete", ProjectController, :team_projects_category_dev_complete
    get "/team_projects/category/count/qa", ProjectController, :team_projects_category_qa
    get "/team_projects/category/count/deployed", ProjectController, :team_projects_category_deployed
    # team project status counters overview
    get "/team_projects/overview/count/not_started", ProjectController, :team_projects_overview_not_started
    get "/team_projects/overview/count/planning", ProjectController, :team_projects_overview_planning
    get "/team_projects/overview/count/under_investigation", ProjectController, :team_projects_overview_under_investigation
    get "/team_projects/overview/count/on_hold", ProjectController, :team_projects_overview_hold
    get "/team_projects/overview/count/in_progress", ProjectController, :team_projects_overview_in_progress
    get "/team_projects/overview/count/dev_complete", ProjectController, :team_projects_overview_dev_complete
    get "/team_projects/overview/count/qa", ProjectController, :team_projects_overview_qa
    get "/team_projects/overview/count/deployed", ProjectController, :team_projects_overview_deployed

    # Live Issues Counters
    get "/live_issues/active/count", ProjectController, :active_live_issues_counter
    get "/live_issues/team/active/count", ProjectController, :active_team_live_issues_counter

############## Project Assignments ##########################
    get "/project_assignment/all", AssignmentController, :get_project_assignments
    get "/project_assignment/team/project_type", AssignmentController, :get_team_project_assignments_project_type
    get "/project_assignment/project_type", AssignmentController, :get_project_assignments_project_type
    get "/project_assignment/member", AssignmentController, :get_project_assigned_member
    get "/project_assignment/team", AssignmentController, :get_project_assigned_team
    get "/project_assignment/details", AssignmentController, :get_project_assigned_details
    get "/project_assignment/dev", AssignmentController, :get_project_dev_assigned
    get "/project_assignment/dev/project_type", AssignmentController, :project_user_assigned
    
    #search
    get "/project_assignment/team/search", AssignmentController, :team_project_assignments_search
    get "/project_assignment/dev/search", AssignmentController, :user_project_assignments_search


    post "/project_assignment/assign", AssignmentController, :assign_project
    put "/project_assignment/update", AssignmentController, :update_assignment_details
    delete "/project_assignment/delete", AssignmentController, :un_assign_member

  ####### Counters #####
    get "/project_assignments/user/count/all", AssignmentController, :user_project_assignment
    get "/project_assignments/user/count/completed", AssignmentController, :user_completed_project_assignment
    get "/project_assignments/user/count/pending", AssignmentController, :user_pending_project_assignment


######### Task Controller #########

    get "/tasks/all", TaskController, :get_tasks
    get "/tasks/active", TaskController, :get_active_tasks
    get "/tasks/not_active", TaskController, :get_not_active_tasks

    ### Team ##
    get "/team/tasks/all", TaskController, :get_team_tasks
    get "/team/tasks/active", TaskController, :get_active_team_tasks
    get "/team/tasks/not_active", TaskController, :get_not_active_team_tasks
    get "/team/tasks/open", TaskController, :open_team_tasks
    get "/team/tasks/over_due", TaskController, :over_due_team_tasks

    get "/team/tasks/counters", TaskController, :get_team_tasks_counter
      ### User or Dev ##
      get "/user/tasks/all", TaskController, :get_user_tasks
      get "/user/tasks/active/open", TaskController, :get_open_user_tasks
      get "/user/tasks/active", TaskController, :get_active_user_tasks
      get "/user/tasks/not_active", TaskController, :get_not_active_user_tasks
      get "/user/tasks/over_due", TaskController, :over_due_user_tasks
      get "/user/tasks/completed", TaskController, :completed_user_tasks

    post "/task/create", TaskController, :create_task

    #update (deactivate task, activate task, update)
    put "/task/update", TaskController, :update_task
    put "/task/activate", TaskController, :activate_task
    put "/task/deactivate", TaskController, :de_activate_task

    delete "/task/delete", TaskController, :delete_task

      #### counters ######
      # User/Dev #
      get "/task/user/count/all", TaskController, :user_all_tasks
      get "/task/user/count/completed", TaskController, :user_completed_tasks
      get "/task/user/count/pending", TaskController, :user_not_completed_tasks
      get "/task/user/count/over_due", TaskController, :user_tasks_overdue
        # user task status counter
        get "/user/tasks_status/count/not_started", TaskController, :user_tasks_not_started
        get "/user/tasks_status/count/on_hold", TaskController, :user_tasks_on_hold
        get "/user/tasks_status/count/in_progress", TaskController, :user_tasks_in_progress
        get "/user/tasks_status/count/testing", TaskController, :user_tasks_testing
        get "/user/tasks_status/count/completed", TaskController, :user_tasks_completed


      # Team #
      get "/task/team/count/all", TaskController, :team_all_tasks
      get "/task/team/count/completed", TaskController, :team_completed_tasks
      get "/task/team/count/pending", TaskController, :team_not_completed_tasks
      get "/task/team/count/over_due", TaskController, :team_tasks_overdue

      get "/task/team/count", TaskController, :get_team_tasks_counter

        # team task status counter
        get "/team/tasks_status/count/not_started", TaskController, :team_tasks_not_started
        get "/team/tasks_status/count/on_hold", TaskController, :team_tasks_on_hold
        get "/team/tasks_status/count/in_progress", TaskController, :team_tasks_in_progress
        get "/team/tasks_status/count/testing", TaskController, :team_tasks_testing
        get "/team/tasks_status/count/completed", TaskController, :team_tasks_completed
   
        get "/team/task_status", TaskController, :get_team_tasks_status_counter
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: KrystalMathApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
