defmodule KrystalMathApiWeb.TaskStatusView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.TaskStatusView

  def render("index.json", %{task_statuses: task_statuses}) do
    %{data: render_many(task_statuses, TaskStatusView, "task_status.json")}
  end

  def render("show.json", %{task_status: task_status}) do
    %{data: render_one(task_status, TaskStatusView, "task_status.json")}
  end

  def render("task_status.json", %{task_status: task_status}) do
    %{
      id: task_status.id,
      name: task_status.name,
      level: task_status.level
    }
  end
end
