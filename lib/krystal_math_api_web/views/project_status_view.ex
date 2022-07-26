defmodule KrystalMathApiWeb.ProjectStatusView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.ProjectStatusView

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
end
