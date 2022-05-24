defmodule KrystalMathApiWeb.UserRoleView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.UserRoleView
  
  def render("index.json", %{user_roles: user_roles}) do
    %{data: render_many(user_roles, UserRoleView, "role_members.json")}
  end

  def render("show.json", %{user_role: user_role}) do
    %{data: render_one(user_role, UserRoleView, "role_members.json")}
  end
  def render("show_update.json", %{user_role: user_role}) do
    %{data: render_one(user_role, UserRoleView, "role.json")}
  end

  def render("role_members.json", %{user_role: user_role}) do
    %{
      id: user_role.id,
      name: user_role.name
    }
  end

  def render("role.json", %{user_role: user_role}) do
    %{
      id: user_role.id,
      name: user_role.name
    }
  end

end
