defmodule KrystalMathApiWeb.PriorityTypeView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.PriorityTypeView

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

end
