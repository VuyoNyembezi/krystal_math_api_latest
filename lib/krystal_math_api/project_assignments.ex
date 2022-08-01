defmodule KrystalMathApi.ProjectAssignments do
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Projects.ProjectAssignment
  alias KrystalMathApi.Projects.CategoriesAndImportance.{ProjectType, ProjectCategoryType, Status}
  alias KrystalMathApi.Projects.Project

  # Get Project Statust 

  def active_users do
    query =
      from(u in "users",
        join: t in "teams",
        on: t.id == u.team_id,
        select: %{
          id: u.id,
          email: u.email,
          password: u.password,
          employee_code: u.employee_code,
          name: u.name,
          last_name: u.last_name,
          team: t.name,
          team_id: u.team_id,
          password_reset: u.password_reset,
          is_active: u.is_active,
          is_admin: u.is_admin
        },
        where: u.is_active == true
      )

    Repo.all(query)
  end

  defp get_project_types do
    query = from(pt in ProjectType, order_by: [asc: pt.id], select: {pt.id, pt.name})
    Repo.all(query)
  end

  defp project_type_values do
    types = get_project_types()

    [
      {bet_projects_id, _bet_project},
      {country_id, _country},
      {customer_journey_id, _customer_journey},
      {integration_id, _integration},
      {payment_methods_id, _payment_methods},
      {digital_marketing_id, _digital_marketing},
      {bet_software_partners_id, _bet_software_partners}
    ] = types

    {project_types} =
      {%{
         bet_projects_id: bet_projects_id,
         country_id: country_id,
         customer_journey_id: customer_journey_id,
         payment_methods_id: payment_methods_id,
         integration_id: integration_id,
         digital_marketing_id: digital_marketing_id,
         bet_software_partners_id: bet_software_partners_id
       }}

    project_types
  end

  # Get Project Category 

  # Get Project Category 

  def get_project_categories do
    query = from(pct in ProjectCategoryType, order_by: [asc: pct.id], select: {pct.id, pct.name})
    Repo.all(query)
  end

  defp project_category_type_values do
    categories = get_project_categories()

    [
      {operational_project_id, _operational_project},
      {strategic_project_id, _strategic}
    ] = categories

    {project_categories} =
      {%{
         operational_project_id: operational_project_id,
         strategic_project_id: strategic_project_id
       }}

    project_categories
  end

  ####### SEARCH METHODS #################

  # search for projects filtered by team id 
  def team_project_assignment_search(team_id, project_type, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(pa in ProjectAssignment,
        join: p in Project,
        on: p.id == pa.project_id,
        where:
          like(p.name, ^search_name) and pa.team_id == ^team_id and
            pa.project_type_id == ^project_type
      )
    )
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  # search team assignment 

  def team_search_assignment(team_id, search_term) do
    project_types = project_type_values()

    [team_assignment] = [
      %{
        bet_projects:
          team_project_assignment_search(team_id, project_types.bet_projects_id, search_term),
        country_projects:
          team_project_assignment_search(team_id, project_types.country_id, search_term),
        customer_journey_projects:
          team_project_assignment_search(team_id, project_types.customer_journey_id, search_term),
        integrations_projects:
          team_project_assignment_search(team_id, project_types.integration_id, search_term),
        payment_method_projects:
          team_project_assignment_search(team_id, project_types.payment_methods_id, search_term),
        digital_marketing_projects:
          team_project_assignment_search(team_id, project_types.digital_marketing_id, search_term),
        bet_project_partners_projects:
          team_project_assignment_search(
            team_id,
            project_types.bet_software_partners_id,
            search_term
          )
      }
    ]

    team_assignment
  end

  # search for projects assignment filtered by team id and user id
  def user_project_assignment_search(team_id, project_type, user_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(pa in ProjectAssignment,
        join: p in Project,
        on: p.id == pa.project_id,
        where:
          like(p.name, ^search_name) and pa.team_id == ^team_id and pa.user_id == ^user_id and
            pa.project_type_id == ^project_type
      )
    )
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  # search dev project assignment  search 

  def user_search_assignment(team_id, user_id, search_term) do
    project_types = project_type_values()

    [user_assignment] = [
      %{
        bet_projects:
          user_project_assignment_search(
            team_id,
            project_types.bet_projects_id,
            user_id,
            search_term
          ),
        country_projects:
          user_project_assignment_search(
            team_id,
            project_types.country_id,
            user_id,
            search_term
          ),
        customer_journey_projects:
          user_project_assignment_search(
            team_id,
            project_types.customer_journey_id,
            user_id,
            search_term
          ),
        integrations_projects:
          user_project_assignment_search(
            team_id,
            project_types.integration_id,
            user_id,
            search_term
          ),
        payment_method_projects:
          user_project_assignment_search(
            team_id,
            project_types.payment_methods_id,
            user_id,
            search_term
          ),
        digital_marketing_projects:
          user_project_assignment_search(
            team_id,
            project_types.digital_marketing_id,
            user_id,
            search_term
          )
        #  bet_project_partners_projects: user_project_assignment_search(team_id , project_types.bet_software_partners_id,user_id,search_term)
      }
    ]

    user_assignment
  end

  @doc """
  get record of bet project assignment  by id
  """

  def get_assignment_project!(id) do
    ProjectAssignment
    |> Repo.get!(id)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  # list all  projects asignments
  def list_assigned_projects do
    ProjectAssignment
    |> Repo.all()
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all projects assignements by project type (Live Issues , Operational, Strategic)
  """
  def all_projects_assignments_project_type(project_type) do
    query = from(a in ProjectAssignment, where: a.project_type_id == ^project_type)

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all projects assignements to member
  """
  def all_projects_assignment_to_member(user_id) do
    query = from(a in ProjectAssignment, where: a.user_id == ^user_id)

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all projects assignements to a Team
  """
  def all_projects_assignment_to_team(team_id) do
    query =
      from(a in ProjectAssignment,
        where: a.due_date >= ^DateTime.utc_now() and a.team_id == ^team_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all over due projects assignements to a Team
  """
  def all_over_due_projects_assignment_to_team(team_id) do
    query =
      from(a in ProjectAssignment,
        where: a.due_date <= ^DateTime.utc_now() and a.team_id == ^team_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all assigned assigned members on the project
  """
  def get_project_assigned_details(team_id, project_id) do
    query =
      from(a in ProjectAssignment,
        where: a.team_id == ^team_id and a.project_id == ^project_id and a.user_id != 2
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all assigned assigned record by project, type
  """
  def get_project_assigned_type(team_id, project_type) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date >= ^DateTime.utc_now() and a.team_id == ^team_id and
            a.project_type_id == ^project_type and a.user_id != 2
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  def get_project_assigned_all(team_id) do
    query =
      from(a in ProjectAssignment,
        where: a.due_date >= ^DateTime.utc_now() and a.team_id == ^team_id and a.user_id != 2
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  gets all overdue team record by project, type
  """
  def get_over_due_project_assigned_type(team_id, project_type) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date <= ^DateTime.utc_now() and a.team_id == ^team_id and
            a.project_type_id == ^project_type and a.user_id != 2
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  def get_over_due_project_assigned_all(team_id) do
    query =
      from(a in ProjectAssignment,
        where: a.due_date <= ^DateTime.utc_now() and a.team_id == ^team_id and a.user_id != 2
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  # Map Fucntion  (Open Projects)
  def team_project_assignments(team_id) do
    project_types = project_type_values()

    [team_assignment] = [
      %{
        bet_projects: get_project_assigned_type(team_id, project_types.bet_projects_id),
        country_projects: get_project_assigned_type(team_id, project_types.country_id),
        customer_journey_projects:
          get_project_assigned_type(team_id, project_types.customer_journey_id),
        integrations_projects: get_project_assigned_type(team_id, project_types.integration_id),
        payment_method_projects:
          get_project_assigned_type(team_id, project_types.payment_methods_id),
        digital_marketing_projects:
          get_project_assigned_type(team_id, project_types.digital_marketing_id),
        bet_project_partners_projects:
          get_project_assigned_type(team_id, project_types.bet_software_partners_id),
        all_projects: get_project_assigned_all(team_id)
      }
    ]

    team_assignment
  end

  # Map Fucntion 
  def team_over_due_project_assignments(team_id) do
    project_types = project_type_values()

    [team_assignment] = [
      %{
        bet_projects: get_over_due_project_assigned_type(team_id, project_types.bet_projects_id),
        country_projects: get_over_due_project_assigned_type(team_id, project_types.country_id),
        customer_journey_projects:
          get_over_due_project_assigned_type(team_id, project_types.customer_journey_id),
        integrations_projects:
          get_over_due_project_assigned_type(team_id, project_types.integration_id),
        payment_method_projects:
          get_over_due_project_assigned_type(team_id, project_types.payment_methods_id),
        digital_marketing_projects:
          get_over_due_project_assigned_type(team_id, project_types.digital_marketing_id),
        bet_project_partners_projects:
          get_over_due_project_assigned_type(team_id, project_types.bet_software_partners_id),
        all_projects: get_over_due_project_assigned_all(team_id)
      }
    ]

    team_assignment
  end

  ### DEV/User  Assigned ###

  @doc """
  get projects assigned to the user
  """
  def get_dev_assigned_projects(team_id, user_id) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date >= ^DateTime.utc_now() and a.team_id == ^team_id and a.user_id == ^user_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  get over due projects assigned to the user
  """
  def get_over_due_dev_assigned_projects(team_id, user_id) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date <= ^DateTime.utc_now() and a.team_id == ^team_id and a.user_id == ^user_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  get projects assigned to the user by project Type 
  """
  def project_type_dev_assigned(team_id, project_type, user_id) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date >= ^DateTime.utc_now() and a.team_id == ^team_id and
            a.project_type_id == ^project_type and a.user_id == ^user_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  @doc """
  get all overdue projects assigned to the user by project Type 
  """
  def over_due_project_type_dev_assigned(team_id, project_type, user_id) do
    query =
      from(a in ProjectAssignment,
        where:
          a.due_date <= ^DateTime.utc_now() and a.team_id == ^team_id and
            a.project_type_id == ^project_type and a.user_id == ^user_id
      )

    Repo.all(query)
    |> Repo.preload([:project, :user, :project_category_type, :project_type, :user_status, :team])
  end

  # Map Fucntion Open Projects Assign
  def dev_project_assignments(team_id, user_id) do
    project_types = project_type_values()

    [dev_assignment] = [
      %{
        bet_projects: project_type_dev_assigned(team_id, project_types.bet_projects_id, user_id),
        country_projects: project_type_dev_assigned(team_id, project_types.country_id, user_id),
        customer_journey_projects:
          project_type_dev_assigned(team_id, project_types.customer_journey_id, user_id),
        integrations_projects:
          project_type_dev_assigned(team_id, project_types.integration_id, user_id),
        payment_method_projects:
          project_type_dev_assigned(team_id, project_types.payment_methods_id, user_id),
        digital_marketing_projects:
          project_type_dev_assigned(team_id, project_types.digital_marketing_id, user_id),
        bet_project_partners_projects:
          project_type_dev_assigned(team_id, project_types.bet_software_partners_id, user_id),
        all_projects: get_dev_assigned_projects(team_id, user_id)
      }
    ]

    dev_assignment
  end

  def dev_over_due_project_assignments(team_id, user_id) do
    project_types = project_type_values()

    [dev_assignment] = [
      %{
        bet_projects:
          over_due_project_type_dev_assigned(team_id, project_types.bet_projects_id, user_id),
        country_projects:
          over_due_project_type_dev_assigned(team_id, project_types.country_id, user_id),
        customer_journey_projects:
          over_due_project_type_dev_assigned(team_id, project_types.customer_journey_id, user_id),
        integrations_projects:
          over_due_project_type_dev_assigned(team_id, project_types.integration_id, user_id),
        payment_method_projects:
          over_due_project_type_dev_assigned(team_id, project_types.payment_methods_id, user_id),
        digital_marketing_projects:
          over_due_project_type_dev_assigned(team_id, project_types.digital_marketing_id, user_id),
        bet_project_partners_projects:
          over_due_project_type_dev_assigned(
            team_id,
            project_types.bet_software_partners_id,
            user_id
          ),
        all_projects: get_over_due_dev_assigned_projects(team_id, user_id)
      }
    ]

    dev_assignment
  end

  def user_assignment_check(team_id, user_id) do
    query =
      from(p in ProjectAssignment,
        select: count(p.id),
        where: p.team_id == ^team_id and p.user_id == ^user_id
      )

    assignments = Repo.one(query)
    max_assigned = 6

    cond do
      max_assigned > assignments ->
        {:ok, assignments}

      assignments >= max_assigned ->
        {:error, assignments}
    end
  end

  defp user_assignment_checker(team_id, user_id) do
    query =
      from(p in ProjectAssignment,
        select: count(p.id),
        where: p.team_id == ^team_id and p.user_id == ^user_id
      )

    Repo.one(query)
  end

  def assignments_progress(team_id, user_id) do
    max_assigned = 6

    assignments_keys = %{
      project_assignments: user_assignment_checker(team_id, user_id),
      max_value: max_assigned
    }

    assignments_keys
  end

  # Add Assignment Record bet projects
  def create_project_assignment(attrs \\ %{}) do
    %ProjectAssignment{}
    |> ProjectAssignment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update bet project Assignement  details
  """
  def update_project_assign(%ProjectAssignment{} = projects_assignment, attrs) do
    projects_assignment
    |> ProjectAssignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  deletes the record of the Assignment
  """

  def delete_assign_member(%ProjectAssignment{} = projects_assignment) do
    Repo.delete(projects_assignment)
  end

  ######  COUNTERS ##############

  def user_assignment_all(team_id, category_id, user_id) do
    assignments =
      from(p in ProjectAssignment,
        select: count(p.id),
        where:
          p.project_category_type_id == ^category_id and p.team_id == ^team_id and
            p.user_id == ^user_id
      )

    # IO.inspect()

    Repo.one(assignments)
  end

  def user_completed_assignment(team_id, category_id, user_id) do
    completed = 6

    completed_assignments =
      from(p in ProjectAssignment,
        select: count(p.id),
        where:
          p.project_category_type_id == ^category_id and p.team_id == ^team_id and
            p.user_id == ^user_id and p.user_status_id == ^completed
      )

    Repo.one(completed_assignments)
  end

  def user_pending_assignment(team_id, category_id, user_id) do
    completed = 6

    pending_assignments =
      from(p in ProjectAssignment,
        select: count(p.id),
        where:
          p.project_category_type_id == ^category_id and p.team_id == ^team_id and
            p.user_id == ^user_id and p.user_status_id != ^completed
      )

    Repo.one(pending_assignments)
  end

  def user_assignment(team_id, category_id, user_id) do
    user_assignment_counters = %{
      all_assignments: user_assignment_all(team_id, category_id, user_id),
      completed: user_completed_assignment(team_id, category_id, user_id),
      pending: user_pending_assignment(team_id, category_id, user_id)
    }

    user_assignment_counters
  end

  def user_operational_assignment(team_id, user_id) do
    project_category = project_category_type_values()

    user_assignment_counters = %{
      all_assignments:
        user_assignment_all(team_id, project_category.operational_project_id, user_id),
      completed:
        user_completed_assignment(team_id, project_category.operational_project_id, user_id),
      pending: user_pending_assignment(team_id, project_category.operational_project_id, user_id)
    }

    user_assignment_counters
  end

  def user_strategic_assignment(team_id, user_id) do
    project_category = project_category_type_values()

    user_assignment_counters = %{
      all_assignments:
        user_assignment_all(team_id, project_category.strategic_project_id, user_id),
      completed:
        user_completed_assignment(team_id, project_category.strategic_project_id, user_id),
      pending: user_pending_assignment(team_id, project_category.strategic_project_id, user_id)
    }

    user_assignment_counters
  end
end
