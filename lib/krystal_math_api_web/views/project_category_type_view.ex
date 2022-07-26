defmodule KrystalMathApiWeb.ProjectCategoryTypeView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.ProjectCategoryTypeView

  def render("index.json", %{project_categories: project_categories}) do
    %{data: render_many(project_categories, ProjectCategoryTypeView, "project_category.json")}
  end

  def render("project_category.json", %{project_category_type: project_category_type}) do
    %{
      id: project_category_type.id,
      name: project_category_type.name
    }
  end

  def render("show.json", %{project_category_type: project_category_type}) do
    %{data: render_one(project_category_type, ProjectCategoryTypeView, "project_category.json")}
  end
end
