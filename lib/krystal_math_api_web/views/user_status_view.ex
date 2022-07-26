defmodule KrystalMathApiWeb.UserStatusView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.UserStatusView

  def render("index.json", %{user_statuses: user_statuses}) do
    %{data: render_many(user_statuses, UserStatusView, "user_status.json")}
  end

  def render("show.json", %{user_status: user_status}) do
    %{data: render_one(user_status, UserStatusView, "user_status.json")}
  end

  def render("user_status.json", %{user_status: user_status}) do
    %{
      id: user_status.id,
      name: user_status.name
    }
  end
end
