defmodule KrystalMathApi.Projects do
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.LiveIssues
  alias KrystalMathApi.Projects.{Project}
  alias KrystalMathApi.Projects.CategoriesAndImportance.{ProjectType, ProjectCategoryType, Status}
  alias KrystalMathApi.Operations.Team

  # projects context

  # Get Project Types

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

  def get_project_types_all do
    all_project_types = from(pt in ProjectType)
    Repo.all(all_project_types)
  end

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

  # Get Project Statust 

  defp get_project_status do
    query = from(status in Status, order_by: [asc: status.id], select: {status.id, status.name})
    Repo.all(query)
  end

  defp project_status_values do
    statuses = get_project_status()

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

    {project_statuses} =
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

    project_statuses
  end

  # Get Team

  defp get_team(team_name) do
    query = from(t in Team, select: t.id, where: t.name == ^team_name)
    Repo.one(query)
  end

  ### SEARCH METHODS ######

  # search for projects
  def all_project_search(search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where: like(p.name, ^search_name)
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # search for projects filtered by project category (Operational, Strategic)
  # All Operational Search
  def project_operational_category_search(search_term) do
    project_category = project_category_type_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and
            p.project_category_type_id == ^project_category.operational_project_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # All strategic search
  def project_strategic_category_search(search_term) do
    project_category = project_category_type_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and
            p.project_category_type_id == ^project_category.strategic_project_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # search for projects filtered by project category (Operational, Strategic) and team id and project Type
  def project_type_search(category_type, project_type, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and p.project_category_type_id == ^category_type and
            p.project_type_id == ^project_type
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Team projects
  defp get_all_projects_search(category_type, search_term) do
    search_name = "%#{search_term}%"

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: like(p.name, ^search_name) and p.project_category_type_id == ^category_type
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Map Search For Operational 
  def all_operational_project_type_search(search_term) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [search_project] = [
      %{
        bet_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.bet_projects_id,
            search_term
          ),
        country_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.country_id,
            search_term
          ),
        customer_journey_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.customer_journey_id,
            search_term
          ),
        integrations_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.integration_id,
            search_term
          ),
        payment_method_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.payment_methods_id,
            search_term
          ),
        digital_marketing_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.digital_marketing_id,
            search_term
          ),
        bet_project_partners_projects:
          project_type_search(
            project_category.operational_project_id,
            project_types.bet_software_partners_id,
            search_term
          ),
        all_projects:
          get_all_projects_search(project_category.operational_project_id, search_term)
      }
    ]

    search_project
  end

  # Map Search For Strategic  
  def all_strategic_project_type_search(search_term) do
    project_category = project_category_type_values()
    project_types = project_type_values()

    [search_project] = [
      %{
        bet_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.bet_projects_id,
            search_term
          ),
        country_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.country_id,
            search_term
          ),
        customer_journey_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.customer_journey_id,
            search_term
          ),
        integrations_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.integration_id,
            search_term
          ),
        payment_method_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.payment_methods_id,
            search_term
          ),
        digital_marketing_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.digital_marketing_id,
            search_term
          ),
        bet_project_partners_projects:
          project_type_search(
            project_category.strategic_project_id,
            project_types.bet_software_partners_id,
            search_term
          ),
        all_projects: get_all_projects_search(project_category.strategic_project_id, search_term)
      }
    ]

    search_project
  end

  ### Team Search 
  # search all team projects 
  def team_project_search(team_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where: like(p.name, ^search_name) and p.team_id == ^team_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # search for projects filtered by project category (Operational, Strategic) and team id 
  def team_project_category_search(category_type, team_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and p.project_category_type_id == ^category_type and
            p.team_id == ^team_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Map Team Search For Strategic  
  def team_strategic_project_search(team_id, search_term) do
    project_category = project_category_type_values()
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and
            p.project_category_type_id == ^project_category.strategic_project_id and
            p.team_id == ^team_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Map Team Search For Operational  
  def team_operational_project_search(team_id, search_term) do
    project_category = project_category_type_values()

    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and
            p.project_category_type_id == ^project_category.operational_project_id and
            p.team_id == ^team_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # search for projects filtered by project category (Operational, Strategic) and team id and project Type
  def team_project_type_search(category_type, project_type, team_id, search_term) do
    search_name = "%#{search_term}%"

    Repo.all(
      from(p in Project,
        where:
          like(p.name, ^search_name) and p.project_category_type_id == ^category_type and
            p.project_type_id == ^project_type and p.team_id == ^team_id
      )
    )
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Team projects
  defp get_all_team_projects(team_id, category_type, search_term) do
    search_name = "%#{search_term}%"

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          like(p.name, ^search_name) and p.project_category_type_id == ^category_type and
            p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Map Team Search For Strategic  and Project types
  def team_strategic_project_type_search(team_id, search_term) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [search_project] = [
      %{
        bet_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.bet_projects_id,
            team_id,
            search_term
          ),
        country_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.country_id,
            team_id,
            search_term
          ),
        customer_journey_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.customer_journey_id,
            team_id,
            search_term
          ),
        integrations_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.integration_id,
            team_id,
            search_term
          ),
        payment_method_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.payment_methods_id,
            team_id,
            search_term
          ),
        digital_marketing_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.digital_marketing_id,
            team_id,
            search_term
          ),
        bet_project_partners_projects:
          team_project_type_search(
            project_category.strategic_project_id,
            project_types.bet_software_partners_id,
            team_id,
            search_term
          ),
        all_projects:
          get_all_team_projects(team_id, project_category.strategic_project_id, search_term)
      }
    ]

    search_project
  end

  # Map Team Search For Operational  and Project types
  def team_operational_project_type_search(team_id, search_term) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [search_project] = [
      %{
        bet_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.bet_projects_id,
            team_id,
            search_term
          ),
        country_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.country_id,
            team_id,
            search_term
          ),
        customer_journey_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.customer_journey_id,
            team_id,
            search_term
          ),
        integrations_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.integration_id,
            team_id,
            search_term
          ),
        payment_method_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.payment_methods_id,
            team_id,
            search_term
          ),
        digital_marketing_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.digital_marketing_id,
            team_id,
            search_term
          ),
        bet_project_partners_projects:
          team_project_type_search(
            project_category.operational_project_id,
            project_types.bet_software_partners_id,
            team_id,
            search_term
          ),
        all_projects:
          get_all_team_projects(team_id, project_category.operational_project_id, search_term)
      }
    ]

    search_project
  end

  def get_all_projects do
    all_projects = from(p in Project, order_by: [desc: p.priority_type_id])

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # get project by Id
  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Team project by project category
  def team_projects_category_type(team_id, category_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_category_type_id == ^category_type and p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Strategic and operational projects
  defp team_projects_category(category_type, team_id) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_category_type_id == ^category_type and p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Strategic team projects 
  def team_strategic_all_projects(team_id) do
    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category.strategic_project_id and
            p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Operational Team Projects 
  def team_operational_all_projects(team_id) do
    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category.operational_project_id and
            p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Team project by project type
  def get_team_projects_type(team_id, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_type_id == ^project_type and p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # Team projects
  defp get_team_projects(team_id) do
    all_projects =
      from(p in Project, order_by: [desc: p.priority_type_id], where: p.team_id == ^team_id)

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  def get_all_team_projects_type(team_id) do
    project_types = project_type_values()

    [team_project] = [
      %{
        bet_projects: get_team_projects_type(team_id, project_types.bet_projects_id),
        country_projects: get_team_projects_type(team_id, project_types.country_id),
        customer_journey_projects:
          get_team_projects_type(team_id, project_types.customer_journey_id),
        integrations_projects: get_team_projects_type(team_id, project_types.integration_id),
        payment_method_projects:
          get_team_projects_type(team_id, project_types.payment_methods_id),
        digital_marketing_projects:
          get_team_projects_type(team_id, project_types.digital_marketing_id),
        bet_project_partners_projects:
          get_team_projects_type(team_id, project_types.bet_software_partners_id),
        all_projects: get_team_projects(team_id)
      }
    ]

    team_project
  end

  ############ Team project by project category & project type
  def team_projects_category_project_type(team_id, category_type, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^category_type and p.project_type_id == ^project_type and
            p.team_id == ^team_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # New Map Team Projects By Category
  def get_all_team_projects_category_project_type(team_id) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [team_category_project] = [
      %{
        operational_team_projects: %{
          bet_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.bet_projects_id
            ),
          country_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.country_id
            ),
          customer_journey_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.customer_journey_id
            ),
          integrations_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.integration_id
            ),
          payment_method_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.payment_methods_id
            ),
          digital_marketing_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.digital_marketing_id
            ),
          bet_project_partners_projects:
            team_projects_category_project_type(
              team_id,
              project_category.operational_project_id,
              project_types.bet_software_partners_id
            ),
          all_projects: team_projects_category(project_category.operational_project_id, team_id)
        },
        strategic_team_projects: %{
          bet_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.bet_projects_id
            ),
          country_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.country_id
            ),
          customer_journey_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.customer_journey_id
            ),
          integrations_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.integration_id
            ),
          payment_method_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.payment_methods_id
            ),
          digital_marketing_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.digital_marketing_id
            ),
          bet_project_partners_projects:
            team_projects_category_project_type(
              team_id,
              project_category.strategic_project_id,
              project_types.bet_software_partners_id
            ),
          all_projects: team_projects_category(project_category.strategic_project_id, team_id)
        }
      }
    ]

    team_category_project
  end

  ############# OPERATIONAL PROJETCS ########
  def operational_projects do
    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_category_type_id == ^project_category.operational_project_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  def unassigned_operational_projects do
    team = %{
      key: get_team("TBA")
    }

    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category.operational_project_id and
            p.team_id == ^team.key
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  def operational_projects_type(project_category, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category and p.project_type_id == ^project_type
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  defp operational_projects(project_category) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_category_type_id == ^project_category
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # New Map
  def get_operational_projects_type do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [projects] = [
      %{
        bet_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.bet_projects_id
          ),
        country_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.country_id
          ),
        customer_journey_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.customer_journey_id
          ),
        integrations_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.integration_id
          ),
        payment_method_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.payment_methods_id
          ),
        digital_marketing_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.digital_marketing_id
          ),
        bet_project_partners_projects:
          operational_projects_type(
            project_category.operational_project_id,
            project_types.bet_software_partners_id
          ),
        all_projects: operational_projects(project_category.operational_project_id)
      }
    ]

    projects
  end

  # #### 

  # All team Projects
  def team_projects(team_id) do
    all_projects =
      from(p in Project, order_by: [desc: p.priority_type_id], where: p.team_id == ^team_id)

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # get team project using  project types
  def team_operational_projects_type(team_id, project_category, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category and p.team_id == ^team_id and
            p.project_type_id == ^project_type
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  #  New Map
  def get_team_operational_projects_type(team_id) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [team_project] = [
      %{
        bet_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.bet_projects_id
          ),
        country_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.country_id
          ),
        customer_journey_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.customer_journey_id
          ),
        integrations_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.integration_id
          ),
        payment_method_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.payment_methods_id
          ),
        digital_marketing_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.digital_marketing_id
          ),
        bet_project_partners_projects:
          team_operational_projects_type(
            team_id,
            project_category.operational_project_id,
            project_types.bet_software_partners_id
          ),
        all_projects: team_projects_category(project_category.operational_project_id, team_id)
      }
    ]

    team_project
  end

  ########### Strategic Projects #########
  # strategic projects
  def strategic_projects do
    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where: p.project_category_type_id == ^project_category.strategic_project_id
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  def unassigned_strategic_projects do
    team = %{
      key: get_team("TBA")
    }

    project_category = project_category_type_values()

    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category.strategic_project_id and
            p.team_id == ^team.key
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  def strategic_projects_type(project_category, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category and p.project_type_id == ^project_type
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # New Map
  def get_strategic_projects_type do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [team_project] = [
      %{
        bet_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.bet_projects_id
          ),
        country_projects:
          strategic_projects_type(project_category.strategic_project_id, project_types.country_id),
        customer_journey_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.customer_journey_id
          ),
        integrations_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.integration_id
          ),
        payment_method_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.payment_methods_id
          ),
        digital_marketing_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.digital_marketing_id
          ),
        bet_project_partners_projects:
          strategic_projects_type(
            project_category.strategic_project_id,
            project_types.bet_software_partners_id
          ),
        all_projects: operational_projects(project_category.strategic_project_id)
      }
    ]

    team_project
  end

  # get all strategic team project 

  # get team project using  project types
  def team_strategic_projects_type(team_id, project_category, project_type) do
    all_projects =
      from(p in Project,
        order_by: [desc: p.priority_type_id],
        where:
          p.project_category_type_id == ^project_category and p.team_id == ^team_id and
            p.project_type_id == ^project_type
      )

    Repo.all(all_projects)
    |> Repo.preload([
      :team,
      :user,
      :project_type,
      :project_category_type,
      :project_status,
      :priority_type
    ])
  end

  # New Map

  def get_team_strategic_projects_type(team_id) do
    project_category = project_category_type_values()

    project_types = project_type_values()

    [team_project] = [
      %{
        bet_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.bet_projects_id
          ),
        country_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.country_id
          ),
        customer_journey_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.customer_journey_id
          ),
        integrations_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.integration_id
          ),
        payment_method_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.payment_methods_id
          ),
        digital_marketing_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.digital_marketing_id
          ),
        bet_project_partners_projects:
          team_strategic_projects_type(
            team_id,
            project_category.strategic_project_id,
            project_types.bet_software_partners_id
          ),
        all_projects: team_projects_category(project_category.strategic_project_id, team_id)
      }
    ]

    team_project
  end

  @doc """
  create new project record
  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update project  record
  """

  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  team  update project  record
  """

  def team_update_project(%Project{} = project, attrs) do
    project
    |> Project.team_changeset(attrs)
    |> Repo.update()
  end

  #########  COUNTERS ##########################

  # project counters
  def all_projects_counter do
    projects =
      from(p in Project,
        select: count(p.id)
      )

    Repo.one(projects)
  end

  #   assigend team assigned  counters
  def all_assigned_projects_counter do
    team = %{
      key: get_team("TBA")
    }

    projects = from(p in Project, select: count(p.id), where: p.team_id != ^team.key)
    Repo.one(projects)
  end

  def all_not_assigned_projects_counter do
    team = %{
      key: get_team("TBA")
    }

    projects = from(p in Project, select: count(p.id), where: p.team_id == ^team.key)
    Repo.one(projects)
  end

  #   completion counters
  defp all_pending_projects_counter do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where: p.project_status_id != ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  defp all_completed_projects_counter do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where: p.project_status_id == ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  #### @@@@ LATEST @@@@####
  @doc """
  calls all projects filter by category and map the into a single varibale
  iex> projects_counter(1)
  """

  def projects_counter() do
    projects_count = %{
      all_project: all_projects_counter(),
      not_assigned: all_not_assigned_projects_counter(),
      assigned: all_assigned_projects_counter(),
      pending: all_pending_projects_counter(),
      completed: all_completed_projects_counter()
    }

    projects_count
  end

  def project_counter_category(category_id) do
    projects =
      from(p in Project, select: count(p.id), where: p.project_category_type_id == ^category_id)

    Repo.one(projects)
  end

  def projects_category_counter do
    project_category = project_category_type_values()

    projects_category_count = %{
      operational: %{
        projects_count: project_counter_category(project_category.operational_project_id)
      },
      strategic: %{
        projects_count: project_counter_category(project_category.operational_project_id)
      },
      live_issues: %{
        projects_count: LiveIssues.all_live_issues_overview()
      }
    }

    projects_category_count
  end

  # All Project Status Counters
  def projects__status(project_status) do
    status =
      from(p in Project,
        select: count(p.project_status_id),
        where: p.project_status_id == ^project_status
      )

    Repo.one(status)
  end

  #### @@@@ LATEST @@@@####
  @doc """
  calls all projects statuses count map the into a single varibale
  iex> projects_statuses(1)
  """
  def projects_statuses() do
    project_status = project_status_values()

    projects_statuses = %{
      not_started: projects__status(project_status.not_started_id),
      planning: projects__status(project_status.planning_id),
      under_investigation: projects__status(project_status.under_investigation_id),
      on_hold: projects__status(project_status.on_hold_id),
      in_progress: projects__status(project_status.in_progress_id),
      dev_complete: projects__status(project_status.dev_complete_id),
      qa: projects__status(project_status.qa_id),
      deployed: projects__status(project_status.deploy_id)
    }

    projects_statuses
  end

  # Project category Counters (Operational, Stratg)

  defp projects_status_category_type(project_status, category_type) do
    status =
      from(p in Project,
        select: count(p.project_status_id),
        where:
          p.project_status_id == ^project_status and p.project_category_type_id == ^category_type
      )

    Repo.one(status)
  end

  #### @@@@ LATEST @@@@####
  @doc """
  calls all projects statuses count map the into a single varibale and filter it by project category
  iex> projects_statuses_category(1)
  """

  def projects_statuses_category(category_type) do
    project_status = project_status_values()

    projects_statuses = %{
      not_started: projects_status_category_type(project_status.not_started_id, category_type),
      planning: projects_status_category_type(project_status.planning_id, category_type),
      under_investigation:
        projects_status_category_type(project_status.under_investigation_id, category_type),
      on_hold: projects_status_category_type(project_status.on_hold_id, category_type),
      in_progress: projects_status_category_type(project_status.in_progress_id, category_type),
      dev_complete: projects_status_category_type(project_status.dev_complete_id, category_type),
      qa: projects_status_category_type(project_status.qa_id, category_type),
      deployed: projects_status_category_type(project_status.deploy_id, category_type)
    }

    projects_statuses
  end

  def overview_projects_statuses do
    project_category = project_category_type_values()

    project_status = project_status_values()

    projects_statuses_category_count = %{
      operational: %{
        not_started:
          projects_status_category_type(
            project_status.not_started_id,
            project_category.operational_project_id
          ),
        planning:
          projects_status_category_type(
            project_status.planning_id,
            project_category.operational_project_id
          ),
        under_investigation:
          projects_status_category_type(
            project_status.under_investigation_id,
            project_category.operational_project_id
          ),
        on_hold:
          projects_status_category_type(
            project_status.on_hold_id,
            project_category.operational_project_id
          ),
        in_progress:
          projects_status_category_type(
            project_status.in_progress_id,
            project_category.operational_project_id
          ),
        dev_complete:
          projects_status_category_type(
            project_status.dev_complete_id,
            project_category.operational_project_id
          ),
        qa:
          projects_status_category_type(
            project_status.qa_id,
            project_category.operational_project_id
          ),
        deployed:
          projects_status_category_type(
            project_status.deploy_id,
            project_category.operational_project_id
          )
      },
      strategic: %{
        not_started:
          projects_status_category_type(
            project_status.not_started_id,
            project_category.strategic_project_id
          ),
        planning:
          projects_status_category_type(
            project_status.planning_id,
            project_category.strategic_project_id
          ),
        under_investigation:
          projects_status_category_type(
            project_status.under_investigation_id,
            project_category.strategic_project_id
          ),
        on_hold:
          projects_status_category_type(
            project_status.on_hold_id,
            project_category.strategic_project_id
          ),
        in_progress:
          projects_status_category_type(
            project_status.in_progress_id,
            project_category.strategic_project_id
          ),
        dev_complete:
          projects_status_category_type(
            project_status.dev_complete_id,
            project_category.strategic_project_id
          ),
        qa:
          projects_status_category_type(
            project_status.qa_id,
            project_category.strategic_project_id
          ),
        deployed:
          projects_status_category_type(
            project_status.deploy_id,
            project_category.strategic_project_id
          )
      }
    }

    projects_statuses_category_count
  end

  ######### Team Projects Counters ############

  def team_projects_counter_all(team_id) do
    projects = from(p in Project, select: count(p.id), where: p.team_id == ^team_id)
    Repo.one(projects)
  end

  # Completed Team Projects
  defp team_completed_projects_counter(team_id) do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where: p.team_id == ^team_id and p.project_status_id == ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  # Pending completion
  defp team_pending_projects_counter(team_id) do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where: p.team_id == ^team_id and p.project_status_id != ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  # Team projects 
  def team_projects_counter(team_id) do
    team_projects_count = %{
      all_project: team_projects_counter_all(team_id),
      pending: team_pending_projects_counter(team_id),
      completed: team_completed_projects_counter(team_id)
    }

    team_projects_count
  end

  # Project Counters By Category
  def team_projects_category_counter_all(team_id, category_id) do
    projects =
      from(p in Project,
        select: count(p.id),
        where: p.team_id == ^team_id and p.project_category_type_id == ^category_id
      )

    Repo.one(projects)
  end

  # Completed Team Projects
  def team_completed_projects_category_counter(team_id, category_id) do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where:
          p.team_id == ^team_id and p.project_category_type_id == ^category_id and
            p.project_status_id == ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  # Pending completion
  def team_pending_projects_category_counter(team_id, category_id) do
    project_status = project_status_values()

    projects =
      from(p in Project,
        select: count(p.id),
        where:
          p.team_id == ^team_id and p.project_category_type_id == ^category_id and
            p.project_status_id != ^project_status.deploy_id
      )

    Repo.one(projects)
  end

  #### @@@@ LATEST @@@@####
  @doc """
  calls all projects overview counts map the into a single varibale
  iex> team_projects_category_counter(1)
  """
  def team_projects_category_counter(team_id, category_id) do
    team_projects_count = %{
      all_project: team_projects_category_counter_all(team_id, category_id),
      pending: team_pending_projects_category_counter(team_id, category_id),
      completed: team_completed_projects_category_counter(team_id, category_id)
    }

    team_projects_count
  end

  #  All Team Project Status Counters

  defp team_projects_status_category_type(team_id, project_status, category_type) do
    status =
      from(p in Project,
        select: count(p.project_status_id),
        where:
          p.project_status_id == ^project_status and p.team_id == ^team_id and
            p.project_category_type_id == ^category_type
      )

    Repo.one(status)
  end

  def team_project_category_status_count(team_id, category_type) do
    project_status = project_status_values()

    team_projects_category_statuses_count = %{
      not_started:
        team_projects_status_category_type(team_id, project_status.not_started_id, category_type),
      planning:
        team_projects_status_category_type(team_id, project_status.planning_id, category_type),
      under_investigation:
        team_projects_status_category_type(
          team_id,
          project_status.under_investigation_id,
          category_type
        ),
      on_hold:
        team_projects_status_category_type(team_id, project_status.on_hold_id, category_type),
      in_progress:
        team_projects_status_category_type(team_id, project_status.in_progress_id, category_type),
      dev_complete:
        team_projects_status_category_type(team_id, project_status.dev_complete_id, category_type),
      qa: team_projects_status_category_type(team_id, project_status.qa_id, category_type),
      deployed:
        team_projects_status_category_type(team_id, project_status.deploy_id, category_type)
    }

    team_projects_category_statuses_count
  end

  # Team overview Counts
  defp team_overview_projects_statuse(project_status, team_id) do
    status =
      from(p in Project,
        select: count(p.project_status_id),
        where: p.project_status_id == ^project_status and p.team_id == ^team_id
      )

    Repo.one(status)
  end

  def team_project_status_count(team_id) do
    project_status = project_status_values()

    team_projects_statuses_count = %{
      not_started: team_overview_projects_statuse(project_status.not_started_id, team_id),
      planning: team_overview_projects_statuse(project_status.planning_id, team_id),
      under_investigation:
        team_overview_projects_statuse(project_status.under_investigation_id, team_id),
      on_hold: team_overview_projects_statuse(project_status.on_hold_id, team_id),
      in_progress: team_overview_projects_statuse(project_status.in_progress_id, team_id),
      dev_complete: team_overview_projects_statuse(project_status.dev_complete_id, team_id),
      qa: team_overview_projects_statuse(project_status.qa_id, team_id),
      deployed: team_overview_projects_statuse(project_status.deploy_id, team_id)
    }

    team_projects_statuses_count
  end

  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
