defmodule KrystalMathApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use KrystalMathApiWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(KrystalMathApiWeb.ErrorView)
    |> render(:"404")
  end

  # un
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(KrystalMathApiWeb.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(KrystalMathApiWeb.ErrorView)
    |> render(:"400")
  end

  # if record already exists
  def call(conn, {:error, :precondition_failed}) do
    conn
    |> put_status(:precondition_failed)
    |> put_view(KrystalMathApiWeb.ErrorView)
    |> render(:"412")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(KrystalMathApiWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
