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
    get "/projects/operational/search/all", ProjectController, :projects_operational_category_search
    get "/projects/strategic/search/all", ProjectController, :projects_strategic_category_search
  
# New Searchh Routes 
    get "/projects/operational/search", ProjectController, :search_operational_projects
    get "/projects/strategic/search", ProjectController, :search_strategic_projects
    # team search
    get "/projects/team/all/search", ProjectController, :all_team_projects_search
    get "/projects/team/category/search", ProjectController, :team_projects_category_search
    # New Routes
    get "/projects/team/operational/search", ProjectController, :team_search_operational_projects
    get "/projects/team/strategic/search", ProjectController, :team_search_strategic_projects



    get "/projects/team/project_type/search", ProjectController, :team_projects_type_search
    get "/projects/team/operational_types/search", ProjectController, :team_search_operational_projects_project_type
    get "/projects/team/strategic_types/search", ProjectController, :team_search_strategic_projects_project_type
  
  
    # All Projects (Operational, Strategic)
    get "/projects/operational/all", ProjectController, :all_operational_projects
    get "/projects/strategic/all", ProjectController, :all_strategic_projects
   
    get "/projects/operational/un_assigned/all", ProjectController, :all_un_assigned_operational_projects
    get "/projects/strategic/un_assigned/all", ProjectController, :all_un_assigned_strategic_projects

    # Get Projects Using Project Types
   
        # New Route Map
        get "/projects/operational", ProjectController, :get_operational_projects_types
        get "/projects/strategic", ProjectController, :get_strategic_projects_types

    # Team Routes 
    get "/team/projects/all", ProjectController, :team_projects
    get "/team/projects/category_type/all", ProjectController, :team_projects_by_category
    get "/team/projects", ProjectController, :team_projects_type
    get "/team/projects/category_and_project_type/all", ProjectController, :team_projects_by_type_and_category
      
    get "/team/projects/operational", ProjectController, :team_operational_project_types
    get "/team/projects/strategic", ProjectController, :team_strategic_project_types

      
    # Create Project
    post "/create/project", ProjectController, :create_new_project
    put "/update/project", ProjectController, :update_project

      ####### Live Issues #############

      # search
      get "/live_issues/all/search", ProjectController, :live_issuses_search
      get "/live_issues/active/search", ProjectController, :active_live_issuses_search
      get "/live_issues/not_active/search", ProjectController, :not_active_live_issuses_search
      get "/live_issues/completed/search", ProjectController, :completed_live_issuses_search

      get "/live_issues/all", ProjectController, :get_live_issuses
      get "/live_issues/status/all", ProjectController, :get_live_issues_status
      get "/live_issues/active/all", ProjectController, :get_active_live_issuses
      get "/live_issues/not_active/all", ProjectController, :get_not_active_live_issuses
      get "/live_issues/completed/all", ProjectController, :get_completed_live_issuses

      # team
      # search
      get "/live_issues/team/search", ProjectController, :team_live_issuses_search
      get "/live_issues/team/active/search", ProjectController, :active_team_live_issuses_search
      get "/live_issues/team/not_active/search", ProjectController, :not_active_team_live_issuses_search
      get "/live_issues/team/completed/search", ProjectController, :completed_team_live_issuses_search

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
    # get "/projects/count", ProjectController, :project_count
 
    get "/projects/count/category", ProjectController, :project_count_by_category
    get "/projects/category/counter", ProjectController, :project_count_category

    # All project Counters
    get "/projects/count", ProjectController, :projects_counter

    # project status counters

    get "/projects_status/count", ProjectController, :projects_status_counter

    # project status counters by category ( Operational, Strategic)

    get "/projects/category/count", ProjectController, :projects_category_statuses
    get "/projects/status/counter", ProjectController, :projects_category_statuses_all
    #Team Project Counters 
    get "/team/project/count", ProjectController, :team_projects_count

    # by category Team Projects

    get "/team/project/category/count", ProjectController, :team_category_projects_count
    
    # team project statuses counters by category (, Operational, Strategic)
    get "/team_projects/category/count", ProjectController, :team_projects_category_statuses

    # team project status counters overview
    get "/team_projects/overview/count", ProjectController, :team_projects_statuses


    # Live Issues Counters
    get "/live_issues/active/count", ProjectController, :active_live_issues_counter
    # Overall Counter
    get "/live_issues/count/overview", ProjectController, :live_issues_counter
    get "/live_issues/count/statuses", ProjectController, :live_issue_status_counter

# TEAM
   
    get "/live_issues/team/count/overview", ProjectController, :team_live_issues_counter
    get "/live_issues/team/count/statuses", ProjectController, :team_live_statuses

############## Project Assignments ##########################
    get "/project_assignment/all", AssignmentController, :get_project_assignments
    get "/project_assignment/team/project_type", AssignmentController, :get_team_project_assignments_project_type
    get "/project_assignment/project_type", AssignmentController, :get_project_assignments_project_type
    get "/project_assignment/member", AssignmentController, :get_project_assigned_member
    get "/project_assignment/team", AssignmentController, :get_project_assigned_team

# New Map Request endpoint 
get "/project_assignment/team/all", AssignmentController, :overview_project_team_assigned
get "/project_assignment/over_due/team/all", AssignmentController, :overview_over_due_project_team_assigned

    
    get "/project_assignment/over_due/team", AssignmentController, :get_over_due_project_assigned_team
    get "/project_assignment/details", AssignmentController, :get_project_assigned_details
    get "/project_assignment/dev", AssignmentController, :get_project_dev_assigned
    get "/project_assignment/over_due/dev", AssignmentController, :get_over_due_project_dev_assigned

    get "/project_assignment/dev/project_type", AssignmentController, :project_user_assigned
    get "/project_assignment/dev/over_due/project_type", AssignmentController, :over_due_project_user_assigned

    # New Map Request endpoint
    get "/project_assignment/dev/all", AssignmentController, :overview_project_dev_assigned
    get "/project_assignment/over_due/dev/all", AssignmentController, :overview_over_due_project_dev_assigned
    
    #search
    get "/project_assignment/team/search", AssignmentController, :team_project_assignments_search
    get "/project_assignment/dev/search", AssignmentController, :user_project_assignments_search

    post "/project_assignment/assign", AssignmentController, :assign_project
    put "/project_assignment/update", AssignmentController, :update_assignment_details
    delete "/project_assignment/delete", AssignmentController, :un_assign_member

  ####### Counters #####
    get "/project_assignments/user/count", AssignmentController, :user_project_assignment
######### Task Controller #########

    # search endpoints
    get "/team/tasks/search", TaskController, :team_tasks_search
    get "/user/tasks/search", TaskController, :user_tasks_search


    get "/tasks/all", TaskController, :get_tasks
    get "/tasks/active", TaskController, :get_active_tasks
    get "/tasks/not_active", TaskController, :get_not_active_tasks

    ### Team ##

    get "team/tasks", TaskController, :team_tasks


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
    put "/task/dev/update", TaskController, :dev_update_task

    put "/task/activate", TaskController, :activate_task
    put "/task/deactivate", TaskController, :de_activate_task

    delete "/task/delete", TaskController, :delete_task

      #### counters ######
      # User/Dev #
      get "/task/user/count", TaskController, :user_tasks_counter
        # user task status counter
      get "/user/tasks_status", TaskController, :user_tasks_status_counter

      # Team #
      get "/task/team/count", TaskController, :get_team_tasks_counter

      # team task status counter
   
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
