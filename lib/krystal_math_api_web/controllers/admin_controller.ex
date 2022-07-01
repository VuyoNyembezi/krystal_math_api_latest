defmodule KrystalMathApiWeb.AdminController do
    use KrystalMathApiWeb, :controller
    alias KrystalMathApi.AdminOperations
    alias KrystalMathApi.Accounts.{Role}
    alias KrystalMathApi.Operations.{Team, Environment, TaskStatus, UserStatus}
    alias KrystalMathApi.Projects.CategoriesAndImportance.{Priority, ProjectType, Status,ProjectCategoryType}

    action_fallback KrystalMathApiWeb.FallbackController

########### User Roles ##########

    def all_user_roles(conn, _paras) do
        user_roles = AdminOperations.list_all_roles()
        render(conn, "index.json", user_roles: user_roles)
    end

    #create role record

    def create_role(conn, %{"user_role_attrs" => role_params}) do
        with {:ok, %Role{} = user_role} <- AdminOperations.create_role(role_params) do
        conn
        |> put_status(:created)
        |> render("role.json",user_role: user_role)
        end
    end

    #update  user status
    def update_user_role(conn, %{"id" => id, "user_role_attrs" => role_params}) do
            user_role = AdminOperations.get_user_role!(id)
            with {:ok, %Role{} = user_role} <- AdminOperations.update_role(user_role, role_params) do
            render(conn, "show.json", user_role: user_role)
            end
    end

    # Delete user Role
    def delete_user_role(conn, %{"id" => id}) do
            user_role = AdminOperations.get_user_role!(id)
            with {:ok,%Role{}} <- AdminOperations.delete_user_role(user_role) do
            conn
            |> put_status(200)
            |> text("user role deleted successfully")
    end
    end

########## Enviroment ##############
    def get_environments(conn, _params) do
        environments = AdminOperations.list_all_environments()
        render(conn, "index.json", environments: environments)
    end

    # add new environment

        def create_environment(conn, %{"environment_attrs" => environment_params}) do
            with {:ok, %Environment{} = environment} <- AdminOperations.add_environment(environment_params) do
            conn
            |> put_status(:created)
            |> render("environment.json", environment: environment)
            end
        end

    #update  environment

        def update_environment(conn, %{"id" => id, "environment_attrs" => environment_params}) do
            environment = AdminOperations.get_environment!(id)
            with {:ok, %Environment{} = environment} <- AdminOperations.update_environment(environment, environment_params) do
            render(conn, "show.json", environment: environment)
            end
        end

    # Delete Enviroment
        def delete_enviroment(conn, %{"id" => id}) do
            environment = AdminOperations.get_environment!(id)
            with {:ok,%Environment{}} <- AdminOperations.delete_enviroment(environment) do
            conn
            |> put_status(200)
            |> text("enviroment deleted successfully")
            end
        end

###########  Teams ###############
    def get_teams(conn, _params) do
        teams = AdminOperations.list_all_teams()
        render(conn, "team_with_leader.json", teams: teams)
    end

    # active teams

    def get_active_teams(conn, _params) do
        teams = AdminOperations.list_active_teams()
        render(conn, "team_with_leader.json", teams: teams)
    end

    # not active team
    def get_not_active_teams(conn, _params) do
        teams = AdminOperations.list_not_active_teams()
        render(conn, "team_with_leader.json", teams: teams)
    end
    # add new team

        def create_team(conn, %{"team_attrs" => team_params}) do
            with {:ok, %Team{} = team} <- AdminOperations.add_team(team_params) do
            conn
            |> put_status(:created)
            |> render("team.json", team: team)
            end
        end

    #update  team
        def update_team_info(conn, %{"id" => id, "team_attrs" => team_params}) do
            team = AdminOperations.get_team!(id)
            with {:ok, %Team{} = team} <- AdminOperations.update_team(team, team_params) do
            render(conn, "show.json", team: team)
            end
        end

     #deactivate  team
     def deactivate_team(conn, %{"id" => id, "team_attrs" => team_params}) do
        team = AdminOperations.get_team!(id)
        with {:ok, %Team{} = team} <- AdminOperations.deactivate_team(team, team_params) do
        render(conn, "show.json", team: team)
        end
    end  

       #activate  team
       def activate_team(conn, %{"id" => id, "team_attrs" => team_params}) do
        team = AdminOperations.get_team!(id)
        with {:ok, %Team{} = team} <- AdminOperations.activate_team(team, team_params) do
        render(conn, "show.json", team: team)
        end
    end

    # Delete Team
        def delete_team(conn, %{"id" => id}) do
            team = AdminOperations.get_team!(id)
            with {:ok,%Team{} } <- AdminOperations.delete_team(team) do
            conn
            |> put_status(200)
            |> text("team deleted successfully")
            end
        end

########## TASK STATUS ##########
    def get_task_status(conn, _params) do
        task_statuses = AdminOperations.list_all_task_status()
        render(conn, "index.json", task_statuses: task_statuses)
    end

    #update  task status
    def update_task_status(conn, %{"id" => id, "task_status_attrs" => task_status_params}) do
        task_status = AdminOperations.get_task_status!(id)
        with {:ok, %TaskStatus{} = task_status} <- AdminOperations.update_task_status(task_status, task_status_params) do
        render(conn, "show.json", task_status: task_status)
        end
    end

    # add new task status

    def create_task_status(conn, %{"task_status_attrs" => task_status_params}) do
        with {:ok, %TaskStatus{} = task_status} <- AdminOperations.add_task_status(task_status_params) do
        conn
        |> put_status(:created)
        |> text("new task status added")
        |> render("task_status.json", task_status: task_status)
        end
    end

    # Delete Task Status
    def delete_task_status(conn, %{"id" => id}) do
        task_status = AdminOperations.get_task_status!(id)
        with {:ok,%TaskStatus{}} <- AdminOperations.delete_task_status(task_status) do
        conn
        |> put_status(200)
        |> text("team deleted successfully")
        end
    end

########## User Statuses ####### 
    #fetch
        def get_user_statuses(conn, _params) do
            user_statuses = AdminOperations.list_all_user_status()
            render(conn, "index.json", user_statuses: user_statuses)
        end
    #create record
        def create_user_status(conn, %{"user_status_attrs" => user_status_params}) do
            with {:ok, %UserStatus{} = user_status} <- AdminOperations.add_user_status(user_status_params) do
            conn
            |> put_status(:created)
            |> text("new user status added")
            |> render("user_status.json", user_status: user_status)
            end
        end
    #update  user status
        def update_user_status(conn, %{"id" => id, "user_status_attrs" => user_status_params}) do
            user_status = AdminOperations.get_user_status!(id)
            with {:ok, %UserStatus{} = user_status} <- AdminOperations.update_user_status(user_status, user_status_params) do
            render(conn, "show.json", user_status: user_status)
            end
        end
    # Delete User Status
        def delete_user_status(conn, %{"id" => id}) do
            user_status = AdminOperations.get_user_status!(id)
            with {:ok,%UserStatus{}} <- AdminOperations.delete_user_status(user_status) do
            conn
            |> put_status(200)
            |> text("team deleted successfully")
            end
        end

####### Project Statuses ########

        def get_project_statuses(conn, _params) do
            project_statuses = AdminOperations.get_all_project_statuses()
            render(conn, "index.json", project_statuses: project_statuses)
        end

        def create_project_status(conn, %{"status" => project_status_params}) do
            with {:ok, %Status{} = project_status} <- AdminOperations.add_project_status(project_status_params) do
            conn
            |> put_status(:created)
            |> text("new status added")
            |> render("show.json", project_status: project_status)
            end
        end

        def update_project_status(conn, %{"id" => id, "status" => project_status_params}) do
            project_status = AdminOperations.get_project_status!(id)
            with {:ok, %Status{} = project_status} <- AdminOperations.update_project_status_value(project_status, project_status_params) do
            render(conn, "show.json", project_status: project_status)
            end
        end

    # Delete Project Status
        def delete_project_status(conn, %{"id" => id}) do
            project_status = AdminOperations.get_project_status!(id)
            with {:ok,%Status{}} <- AdminOperations.delete_project_status(project_status) do
            conn
            |> put_status(200)
            |> text("team deleted successfully")
            end
        end

####### Project Type ############

    def get_project_types(conn, _params) do
        project_types = AdminOperations.get_all_project_types()
        render(conn, "index.json", project_types: project_types)
    end
    # Create Project type Status
    def create_project_type(conn, %{"project_type_attrs" => project_type_params}) do
        with {:ok, %ProjectType{} = project_type} <- AdminOperations.create_project_type(project_type_params) do
        conn
        |> put_status(:created)
        |> text("new project type created")
        |> render("project_type.json", project_type: project_type)
        end
    end
    # Update Project type 
    def update_project_type(conn, %{"id" => id, "project_type_attrs" => project_type_params}) do
        project_type = AdminOperations.get_project_type!(id)
        with {:ok, %ProjectType{} = project_type} <- AdminOperations.update_project_type(project_type, project_type_params) do
        render(conn, "show.json", project_type: project_type)
        end
    end
    # Delete Project type 
    def delete_project_type(conn, %{"id" => id}) do
        project_type = AdminOperations.get_project_type!(id)
        with {:ok,%ProjectType{}} <- AdminOperations.delete_project_type(project_type) do
        conn
        |> put_status(200)
        |> text("project Type deleted successfully")
        end
    end

####### Priority Type ####


    def get_priorities(conn, _params) do
        priority_types = AdminOperations.get_all_priorities()
    render(conn, "index.json", priority_types: priority_types)
   end

   def create_priority(conn, %{"priority" => priority_type_params}) do
    with {:ok, %Priority{} = priority_type} <- AdminOperations.create_priority(priority_type_params) do
      conn
      |> put_status(:created)
      |> text("new priority created")
      |> render("priority_type.json", priority_type: priority_type)
    end
   end

   def update_priority(conn, %{"id" => id, "priority" => priority_type_params}) do
    priority_type = AdminOperations.get_priority!(id)
    with {:ok, %Priority{} = priority_type} <- AdminOperations.update_priority(priority_type, priority_type_params) do
      render(conn, "show.json", priority_type: priority_type)
    end
   end
       # Delete Priority type Status
    def delete_priority_type(conn, %{"id" => id}) do
        priority_type = AdminOperations.get_priority!(id)
        with {:ok,%Priority{} } <- AdminOperations.delete_priority_type(priority_type) do
        conn
        |> put_status(200)
        |> text("Priority Type deleted successfully")
        end
    end

####### Project Category Type ############

    def get_project_category_types(conn, _params) do
        project_categories = AdminOperations.get_all_project_category_types()
        render(conn, "index.json", project_categories: project_categories)
    end

    # Create Project Category  
    def create_project_category_type(conn, %{"project_category" => project_category_params}) do
        with {:ok, %ProjectCategoryType{} = project_category_type} <- AdminOperations.create_project_category(project_category_params) do
        conn
        |> put_status(:created)
        |> text("new project category created")
        |> render("project_category.json", project_category_type: project_category_type)
        end
    end

    # Update Project Category  
    def update_project_category_type(conn, %{"id" => id, "project_category" => project_category_params}) do
        project_category_type = AdminOperations.get_project_category_type!(id)
        with {:ok, %ProjectCategoryType{} = project_category_type} <- AdminOperations.update_project_category_type(project_category_type, project_category_params) do
        render(conn, "show.json", project_category_type: project_category_type)
        end
    end

    # Delete Project Category Status
    def delete_project_category_type(conn, %{"id" => id}) do
        project_category_type = AdminOperations.get_project_category_type!(id)
        with {:ok,%ProjectCategoryType{}} <- AdminOperations.delete_project_category_type(project_category_type) do
        conn
        |> put_status(200)
        |> text("project category deleted successfully")
        end
    end

end