defmodule KrystalMathApi.LiveIssues do
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Projects.LiveIssue

  alias KrystalMathApi.Projects.CategoriesAndImportance.Status
  ########### Live Issues ############

  defp get_live_issue_status do
    query = from(status in Status, order_by: [asc: status.id], select: {status.id, status.name})
    Repo.all(query)
  end

  defp live_issues_status_values do
    statuses = get_live_issue_status()

    [
      {not_started_id, _not_started_name},
      {planning_id, _planning_name},
      {under_investigation_id, _investigation_name},
      {on_hold_id, _on_hold_name},
      {in_progress_id, _in_progress_name},
      {dev_complete_id, _dev_complete_name},
      {qa_id, _qa_name},
      {deploy_id, _deploye_name}
    ] = statuses

    {live_statuses} =
      {%{
         deploy_id: deploy_id,
         dev_complete_id: dev_complete_id,
         in_progress_id: in_progress_id,
         not_started_id: not_started_id,
         on_hold_id: on_hold_id,
         planning_id: planning_id,
         qa_id: qa_id,
         under_investigation_id: under_investigation_id
       }}

    live_statuses
  end

  # Search Live Issues #########
  # search for live_issues
  def all_live_issues_search(search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where: like(p.name, ^search_name)
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # search for all  active live_issues
  def all_active_live_issues_search(search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where: like(p.name, ^search_name) and p.is_active == true
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # search for all  not active live_issues
  def all_not_active_live_issues_search(search_term) do
    project_status = live_issues_status_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where:
          like(p.name, ^search_name) and p.is_active == false and
            p.project_status_id != ^project_status.deploy_id
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # search for all completed live_issues
  def all_completed_active_live_issues_search(search_term) do
    project_status = live_issues_status_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where:
          like(p.name, ^search_name) and p.is_active == false and
            p.project_status_id == ^project_status.deploy_id
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # All over Live Issues Search 

  def live_issues_search(search_term) do
    live_issues_all_search = %{
      all_live_issues: all_live_issues_search(search_term),
      active_live_issues: all_active_live_issues_search(search_term),
      not_active_live_issues: all_not_active_live_issues_search(search_term),
      completed_live_issues: all_completed_active_live_issues_search(search_term)
    }

    live_issues_all_search
  end

  # Team Search

  # search for live_issues
  def all_team_live_issues_search(team_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where: like(p.name, ^search_name) and p.team_id == ^team_id
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # active search for live_issues
  def active_team_live_issues_search(team_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where: like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == true
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # not active search for live_issues
  def not_active_team_live_issues_search(team_id, search_term) do
    project_status = live_issues_status_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where:
          like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == false and
            p.project_status_id != ^project_status.deploy_id
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # completed search for live_issues
  def completed_team_live_issues_search(team_id, search_term) do
    project_status = live_issues_status_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in LiveIssue,
        where:
          like(p.name, ^search_name) and p.team_id == ^team_id and p.is_active == false and
            p.project_status_id == ^project_status.deploy_id
      )
    )
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # All over Live Issues Search 

  def team_live_issues_search(team_id, search_term) do
    live_issues_all_search = %{
      all_live_issues: all_team_live_issues_search(team_id, search_term),
      active_live_issues: active_team_live_issues_search(team_id, search_term),
      not_active_live_issues: not_active_team_live_issues_search(team_id, search_term),
      completed_live_issues: completed_team_live_issues_search(team_id, search_term)
    }

    live_issues_all_search
  end

  # get live issue by Id
  def get_live_issue!(id) do
    LiveIssue
    |> Repo.get!(id)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all live issues 
  def all_live_issues do
    all_live_issues = from(p in LiveIssue, order_by: [desc: p.priority_type_id])

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all live issues filter by status
  def all_live_issues_status(status_type) do
    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.project_status_id == ^status_type
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all active  live issues 
  def all_active_live_issues do
    all_live_issues =
      from(p in LiveIssue, order_by: [desc: p.priority_type_id], where: p.is_active == true)

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all not active  live issues 
  def all_not_active_live_issues do
    project_status = live_issues_status_values()

    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.is_active == false and p.project_status_id != ^project_status.deploy_id
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all comleted active  live issues 
  def all_completed_live_issues do
    project_status = live_issues_status_values()

    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.is_active == false and p.project_status_id == ^project_status.deploy_id
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  def live_issues_overview do
    live_issues_all = %{
      all_live_issues: all_live_issues(),
      active_live_issues: all_active_live_issues(),
      not_active_live_issues: all_not_active_live_issues(),
      completed_live_issues: all_completed_live_issues()
    }

    live_issues_all
  end

  # Team
  # Get all team  live issues 
  def all_team_live_issues(team_id) do
    all_live_issues =
      from(p in LiveIssue, order_by: [desc: p.priority_type_id], where: p.team_id == ^team_id)

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all team  live issues by status type
  def team_live_issues_by_status(team_id, status_type) do
    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.team_id == ^team_id and p.project_status_id == ^status_type
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all active team  live issues 
  def all_active_team_live_issues(team_id) do
    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.team_id == ^team_id and p.is_active == true
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all not active team  live issues 
  def all_not_active_team_live_issues(team_id) do
    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where: p.team_id == ^team_id and p.is_active == false
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Get all comleted active team  live issues 
  def all_completed_team_live_issues(team_id) do
    project_status = live_issues_status_values()

    all_live_issues =
      from(p in LiveIssue,
        order_by: [desc: p.priority_type_id],
        where:
          p.team_id == ^team_id and p.is_active == false and
            p.project_status_id == ^project_status.deploy_id
      )

    Repo.all(all_live_issues)
    |> Repo.preload([:team, :user, :project_status, :priority_type])
  end

  # Team Map Live Issues 
  def team_live_issues_overview(team_id) do
    team_live_issues = %{
      all_live_issues: all_team_live_issues(team_id),
      active_live_issues: all_active_team_live_issues(team_id),
      not_active_live_issues: all_not_active_team_live_issues(team_id),
      completed_live_issues: all_completed_team_live_issues(team_id)
    }

    team_live_issues
  end

  @doc """
  create new live issue record
  """
  def create_live_issue(attrs \\ %{}) do
    %LiveIssue{}
    |> LiveIssue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update project  record
  """

  def update_live_issue(%LiveIssue{} = live_issue, attrs) do
    live_issue
    |> LiveIssue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  update status  record
  """

  def update_status_live_issue(%LiveIssue{} = live_issue, attrs) do
    live_issue
    |> LiveIssue.status_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  delete Live Issue Record
  """
  def delete_live_issues(%LiveIssue{} = live_issue) do
    Repo.delete(live_issue)
  end

  ############### Live Issues Counters ###############

  #  Team Live Issue live_issues Overview
  def active_live_issues do
    project_status = live_issues_status_values()

    live_issue =
      from(p in LiveIssue,
        select: count(p.id),
        where: p.project_status_id != ^project_status.deploy_id and p.is_active == true
      )

    Repo.one(live_issue)
  end

  # Completed Team Live live_issues
  def completed_live_issues do
    project_status = live_issues_status_values()

    live_issues =
      from(p in LiveIssue,
        select: count(p.id),
        where: p.project_status_id == ^project_status.deploy_id and p.is_active == false
      )

    Repo.one(live_issues)
  end

  def all_live_issues_overview do
    live_issue =
      from(p in LiveIssue,
        select: count(p.id)
      )

    Repo.one(live_issue)
  end

  # Pending completion
  def pending_live_issues do
    project_status = live_issues_status_values()

    live_issues =
      from(p in LiveIssue,
        select: count(p.id),
        where: p.project_status_id != ^project_status.deploy_id and p.is_active == true
      )

    Repo.one(live_issues)
  end

  def live_issues_count_overview() do
    live_issues_count = %{
      completed: completed_live_issues(),
      pending: pending_live_issues(),
      all_project: all_live_issues_overview(),
      active: active_live_issues()
    }

    live_issues_count
  end

  # All Project Status Counters

  defp live_issue_status(live_status) do
    status =
      from(p in LiveIssue,
        select: count(p.project_status_id),
        where: p.project_status_id == ^live_status
      )

    Repo.one(status)
  end

  #### @@@@ LATEST @@@@####
  @doc """
  calls all live_issue statuses count map the into a single varibale
  iex> live_issue_statuses(1)
  """
  def live_issue_statuses() do
    project_status = live_issues_status_values()

    live_issue_statuses_count = %{
      not_started: live_issue_status(project_status.not_started_id),
      planning: live_issue_status(project_status.planning_id),
      under_investigation: live_issue_status(project_status.under_investigation_id),
      on_hold: live_issue_status(project_status.on_hold_id),
      in_progress: live_issue_status(project_status.in_progress_id),
      dev_complete: live_issue_status(project_status.dev_complete_id),
      qa: live_issue_status(project_status.qa_id),
      deployed: live_issue_status(project_status.deploy_id)
    }

    live_issue_statuses_count
  end

  # TEAM

  #  Team Live Issue live_issues Overview
  defp active_team_live_issues(team_id) do
    project_status = live_issues_status_values()

    live_issue =
      from(p in LiveIssue,
        select: count(p.id),
        where:
          p.team_id == ^team_id and p.project_status_id != ^project_status.deploy_id and
            p.is_active == true
      )

    Repo.one(live_issue)
  end

  # Completed Team Live live_issues
  defp team_completed_live_issues(team_id) do
    project_status = live_issues_status_values()

    live_issues =
      from(p in LiveIssue,
        select: count(p.id),
        where:
          p.team_id == ^team_id and p.project_status_id == ^project_status.deploy_id and
            p.is_active == false
      )

    Repo.one(live_issues)
  end

  defp team_all_live_issues(team_id) do
    live_issue = from(p in LiveIssue, select: count(p.id), where: p.team_id == ^team_id)
    Repo.one(live_issue)
  end

  # Pending completion
  defp team_pending_live_issues(team_id) do
    project_status = live_issues_status_values()

    live_issues =
      from(p in LiveIssue,
        select: count(p.id),
        where:
          p.team_id == ^team_id and p.project_status_id != ^project_status.deploy_id and
            p.is_active == true
      )

    Repo.one(live_issues)
  end

  def team_live_issues_count(team_id) do
    team_live_issues_counters = %{
      completed: team_completed_live_issues(team_id),
      pending: team_pending_live_issues(team_id),
      all_project: team_all_live_issues(team_id),
      active: active_team_live_issues(team_id)
    }

    team_live_issues_counters
  end

  # Team Live Issues Status overview Counts

  defp team_live_issues_statuses(live_statsus, team_id) do
    status =
      from(p in LiveIssue,
        select: count(p.project_status_id),
        where: p.project_status_id == ^live_statsus and p.team_id == ^team_id
      )

    Repo.one(status)
  end

  def team_live_issues_status_count(team_id) do
    project_status = live_issues_status_values()

    team_live_statuses_count = %{
      not_started: team_live_issues_statuses(project_status.not_started_id, team_id),
      planning: team_live_issues_statuses(project_status.planning_id, team_id),
      under_investigation:
        team_live_issues_statuses(project_status.under_investigation_id, team_id),
      on_hold: team_live_issues_statuses(project_status.on_hold_id, team_id),
      in_progress: team_live_issues_statuses(project_status.in_progress_id, team_id),
      dev_complete: team_live_issues_statuses(project_status.dev_complete_id, team_id),
      qa: team_live_issues_statuses(project_status.qa_id, team_id),
      deployed: team_live_issues_statuses(project_status.deploy_id, team_id)
    }

    team_live_statuses_count
  end

  def change_live_issue(%LiveIssue{} = live_issue, attrs \\ %{}) do
    LiveIssue.changeset(live_issue, attrs)
  end
end
