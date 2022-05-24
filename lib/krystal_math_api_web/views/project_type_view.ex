defmodule KrystalMathApiWeb.ProjectTypeView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.ProjectTypeView

  def render("index.json", %{project_types: project_types}) do
    %{data: render_many(project_types, ProjectTypeView, "project_type.json")}
  end

  def render("project_type.json", %{project_type: project_type}) do
    %{
      id: project_type.id,
      name: project_type.name
    }
  end
  
  def render("show.json", %{project_type: project_type}) do
    %{data: render_one(project_type, ProjectTypeView, "project_type.json")}
  end

end
