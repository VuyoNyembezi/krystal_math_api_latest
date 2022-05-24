defmodule KrystalMathApiWeb.LiveIssueView do
    use KrystalMathApiWeb, :view
    alias KrystalMathApiWeb.{LiveIssueView, ProjectStatusView, PriorityTypeView}
    alias KrystalMathApiWeb.{UserView}
    alias KrystalMathApiWeb.{TeamView}
  
    def render("index.json", %{live_issues: live_issues}) do
      %{data: render_many(live_issues, LiveIssueView, "live_issue_details.json")}
    end
  
    def render("show.json", %{live_issue: live_issue}) do
      %{data: render_one(live_issue, LiveIssueView, "live_issue_details.json")}
    end
  
    def render("live_issue.json", %{live_issue: live_issue}) do
      %{
        id: live_issue.id,
        name: live_issue.name,
        business_request_document_status: live_issue.business_request_document_status,
        business_request_document_link: live_issue.business_request_document_link,
        project_status_id: live_issue.project_status_id,
        pm_id: live_issue.pm_id,
        team_id: live_issue.team_id,
        last_status_change: live_issue.last_status_change,
        assigned_date: live_issue.assigned_date,
        priority_type_id: live_issue.priority_type_id,
        is_active: live_issue.is_active,
        inserted_at: live_issue.inserted_at,
        updated_at: live_issue.updated_at
      }
    end
  
    def render("live_issue_details.json", %{live_issue: live_issue}) do
      %{
        id: live_issue.id,
        name: live_issue.name,
        business_request_document_status: live_issue.business_request_document_status,
        business_request_document_link: live_issue.business_request_document_link,
        last_status_change: live_issue.last_status_change,
        assigned_date: live_issue.assigned_date,
        project_status: render_one(live_issue.project_status, ProjectStatusView, "project_status.json"),
        user: render_one(live_issue.user, UserView, "user.json"),
        team: render_one(live_issue.team, TeamView, "team.json"),
        priority_type: render_one(live_issue.priority_type, PriorityTypeView, "priority_type.json" ),
        is_active: live_issue.is_active,
        inserted_at: live_issue.inserted_at,
        updated_at: live_issue.updated_at
      }
    end
  

# Priority View

    def render("index.json", %{priority_types: priority_types}) do
      %{data: render_many(priority_types, PriorityTypeView, "priority_type.json")}
    end
  
    def render("priority_type.json", %{priority_type: priority_type}) do
      %{
        id: priority_type.id,
        name: priority_type.name,
        level: priority_type.level
      }
    end
    def render("show.json", %{priority_type: priority_type}) do
      %{data: render_one(priority_type, PriorityTypeView, "priority_type.json")}
    end



    # Project Status View

    def render("index.json", %{project_statuses: project_statuses}) do
      %{data: render_many(project_statuses, ProjectStatusView, "project_status.json")}
    end
  
    def render("project_status.json", %{project_status: project_status}) do
      %{
        id: project_status.id,
        name: project_status.name,
        effect: project_status.effect,
        level: project_status.level
      }
    end
    def render("show.json", %{project_status: project_status}) do
      %{data: render_one(project_status, ProjectStatusView, "project_status.json")}
    end




# Team View 

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

    # User View
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
    #display user with team details
  
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
         password: user.password,
         password_reset: user.password_reset,
         is_admin: user.is_admin,
         team: render_one(user.team, TeamView, "team.json"),
         user_role: render_one(user.user_role, UserRoleView, "role.json")}
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
  end
  