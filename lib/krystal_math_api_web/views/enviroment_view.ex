defmodule KrystalMathApiWeb.EnvironmentView do
  use KrystalMathApiWeb, :view
  alias KrystalMathApiWeb.EnvironmentView

  def render("index.json", %{environments: environments}) do
    %{data: render_many(environments, EnvironmentView, "environment.json")}
  end

  def render("environment.json", %{environment: environment}) do
    %{
      id: environment.id,
      name: environment.name
    }
  end
  def render("show.json", %{environment: environment}) do
    %{data: render_one(environment, EnvironmentView, "environment.json")}
  end




end
