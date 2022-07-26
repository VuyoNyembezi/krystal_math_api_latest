defmodule KrystalMathApiWeb.LiveIssueController do
  use KrystalMathApiWeb, :controller
  alias KrystalMathApi.LiveIssues
  alias KrystalMathApi.Projects.LiveIssue

  action_fallback KrystalMathApiWeb.FallbackController
  ########### Live Issues ############
  # search live issues
  def live_issuses_search(conn, %{"search" => search_term}) do
    live_issues = LiveIssues.all_live_issues_search(search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # active 
  # search live issues
  def active_live_issuses_search(conn, %{"search" => search_term}) do
    live_issues = LiveIssues.all_active_live_issues_search(search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # not active 
  # search live issues
  def not_active_live_issuses_search(conn, %{"search" => search_term}) do
    live_issues = LiveIssues.all_not_active_live_issues_search(search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # Completed
  # search live issues
  def completed_live_issuses_search(conn, %{"search" => search_term}) do
    live_issues = LiveIssues.all_completed_active_live_issues_search(search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  def all_live_issues_search(conn, %{"search" => search_term}) do
    live_issue = LiveIssues.live_issues_search(search_term)
    render(conn, "live_overview.json", live_issue: live_issue)
  end

  # search team live issues
  def team_live_issuses_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    live_issues = LiveIssues.all_team_live_issues_search(team_id, search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # active team LiveIssues
  def active_team_live_issuses_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    live_issues = LiveIssues.active_team_live_issues_search(team_id, search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # not active LiveIssues
  def not_active_team_live_issuses_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    live_issues = LiveIssues.not_active_team_live_issues_search(team_id, search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  # completed
  def completed_team_live_issuses_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    live_issues = LiveIssues.completed_team_live_issues_search(team_id, search_term)
    render(conn, "index.json", live_issues: live_issues)
  end

  def team_live_issues_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    live_issue = LiveIssues.team_live_issues_search(team_id, search_term)
    render(conn, "live_overview.json", live_issue: live_issue)
  end

  # Get all  live issue LiveIssues
  def get_live_issuses(conn, _params) do
    live_issues = LiveIssues.all_live_issues()
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get all active live issue LiveIssues
  def get_active_live_issuses(conn, _params) do
    live_issues = LiveIssues.all_active_live_issues()
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get all not active live issue LiveIssues
  def get_not_active_live_issuses(conn, _params) do
    live_issues = LiveIssues.all_not_active_live_issues()
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get all  live issue LiveIssues
  def get_completed_live_issuses(conn, _params) do
    live_issues = LiveIssues.all_completed_live_issues()
    render(conn, "index.json", live_issues: live_issues)
  end

  def all_live_issues_overview(conn, _params) do
    live_issue = LiveIssues.live_issues_overview()
    render(conn, "live_overview.json", live_issue: live_issue)
  end

  # Get all team live issue by  statuse type
  def get_live_issues_status(conn, %{"status_type" => status_type}) do
    live_issues = LiveIssues.all_live_issues_status(status_type)
    render(conn, "index.json", live_issues: live_issues)
  end

  # TEAM
  # Get all team live issue LiveIssues
  def get_all_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = LiveIssues.all_active_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get all team live issue by status id
  def get_all_team_live_issuses_status(conn, %{"team_id" => team_id, "status_type" => status_type}) do
    live_issues = LiveIssues.team_live_issues_by_status(team_id, status_type)
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get active team live issue LiveIssues

  def get_active_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = LiveIssues.all_active_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get not active team live issue LiveIssues
  def get_not_active_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = LiveIssues.all_not_active_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues)
  end

  # Get not active team live issue LiveIssues
  def get_completed_team_live_issuses(conn, %{"team_id" => team_id}) do
    live_issues = LiveIssues.all_completed_team_live_issues(team_id)
    render(conn, "index.json", live_issues: live_issues)
  end

  def team_live_issues_overview(conn, %{"team_id" => team_id}) do
    live_issue = LiveIssues.team_live_issues_overview(team_id)
    render(conn, "live_overview.json", live_issue: live_issue)
  end

  # Create New Record

  def create_new_live_issue(conn, %{"live_issue" => live_issue_params}) do
    with {:ok, %LiveIssue{} = live_issue} <- LiveIssues.create_live_issue(live_issue_params) do
      conn
      |> put_status(:created)
      |> render("live_issue.json", live_issue: live_issue)
    end
  end

  # Update Live Issue  Record

  def update_live_issue(conn, %{"id" => id, "live_issue" => live_issue_params}) do
    live_issue = LiveIssues.get_live_issue!(id)

    with {:ok, %LiveIssue{} = live_issue} <-
           LiveIssues.update_live_issue(live_issue, live_issue_params) do
      render(conn, "show.json", live_issue: live_issue)
    end
  end

  # Update live Issue Status Record
  def update_live_issue_status(conn, %{"id" => id, "live_issue" => live_issue_params}) do
    live_issue = LiveIssues.get_live_issue!(id)

    with {:ok, %LiveIssue{} = live_issue} <-
           LiveIssues.update_status_live_issue(live_issue, live_issue_params) do
      render(conn, "show.json", live_issue: live_issue)
    end
  end

  # Delete Live Issues
  def delete_live_issue(conn, %{"id" => id}) do
    live_issue = LiveIssues.get_live_issue!(id)

    with {:ok, %LiveIssue{} = live_issue} <- LiveIssues.delete_live_issues(live_issue) do
      conn
      |> put_status(200)
      |> text("live issue deleted successfully")
    end
  end

  ############# LIVE ISSUES COUNTER    ################

  def active_live_issues_counter(conn, _params) do
    live_issues_counter = LiveIssues.active_live_issues()
    render(conn, "index.json", live_issues_counter: live_issues_counter)
  end

  def live_issues_counter(conn, _params) do
    project_overview = LiveIssues.live_issues_count_overview()
    render(conn, "live_issue_overview.json", project_overview: project_overview)
  end

  # Live Issues Project status Counter
  def live_issue_status_counter(conn, _params) do
    project_statsuses = LiveIssues.live_issue_statuses()
    render(conn, "project_statuses.json", project_statsuses: project_statsuses)
  end

  # TEAM COUNTERS

  def team_live_issues_counter(conn, %{"team_id" => team_id}) do
    project_overview = LiveIssues.team_live_issues_count(team_id)
    render(conn, "live_issue_overview.json", project_overview: project_overview)
  end

  # Team Overview Live Issues Project Statuses Counters
  def team_live_statuses(conn, %{"team_id" => team_id}) do
    project_statsuses = LiveIssues.team_live_issues_status_count(team_id)
    render(conn, "project_statuses.json", project_statsuses: project_statsuses)
  end
end
