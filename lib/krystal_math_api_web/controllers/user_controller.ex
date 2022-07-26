defmodule KrystalMathApiWeb.UserController do
  use KrystalMathApiWeb, :controller
  alias KrystalMathApi.Accounts.Authentication.Guardian
  alias KrystalMathApi.Accounts
  alias KrystalMathApi.Accounts.User

  action_fallback KrystalMathApiWeb.FallbackController

  # FIRST TIME API EXECUTION METHODS DEAFAULT ADMIN ACCOUNT 
  def admin_initial_get(conn, %{"employee_code" => employee_code}) do
    case Accounts.admin_get(employee_code) do
      {:ok, user} ->
        user = Accounts.get_user!(user.id)
        render(conn, "show.json", user: user)

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "no default admin account"})

        conn
        |> send_resp(404, body)
    end
  end

  def admin_password_initial_update(conn, %{
        "employee_code" => employee_code,
        "password_reset" => password_reset,
        "user" => user_params
      }) do
    case Accounts.update_password_user_check(employee_code, password_reset) do
      {:ok, user} ->
        user = Accounts.get_user!(user.id)

        with {:ok, %User{} = user} <- Accounts.update_password(user, user_params) do
          render(conn, "show.json", user: user)
        end

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "please check input"})

        conn
        |> send_resp(401, body)
    end
  end

  # Search USER ACCOUNTS 
  def accounts_search(conn, %{"search" => search_term}) do
    users = Accounts.user_account_name_search(search_term)
    render(conn, "index.json", users: users)
  end

  # search terminated accounts
  def terminated_accounts_search(conn, %{"search" => search_term}) do
    users = Accounts.terminated_user_account_name_search(search_term)
    render(conn, "index.json", users: users)
  end

  # search user accounts by role
  def role_accounts_search(conn, %{"role_id" => role_id, "search" => search_term}) do
    users = Accounts.user_account_role_search(role_id, search_term)
    render(conn, "index.json", users: users)
  end

  # search team user accounts 
  def team_accounts_search(conn, %{"team_id" => team_id, "search" => search_term}) do
    users = Accounts.user_account_team_search(team_id, search_term)
    render(conn, "index.json", users: users)
  end

  # Returns all the Users registered on the system

  def all_users(conn, _params) do
    users = Accounts.list_all_users()
    render(conn, "index.json", users: users)
  end

  # Get user account by id

  def user_by_role(conn, %{"id" => user_role}) do
    users = Accounts.system_users_roles(user_role)
    render(conn, "index.json", users: users)
  end

  # Get team members by id of the team

  def teams_members(conn, %{"id" => id}) do
    team = Accounts.team_members!(id)
    render(conn, "show_members.json", team: team)
  end

  # get user by employee code
  def get_user_by_employee_code(conn, %{"employee_code" => employee_code}) do
    case Accounts.get_by_employee_code(employee_code) do
      {:ok, user} ->
        user = Accounts.get_user!(user.id)
        render(conn, "show.json", user: user)

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "not found please check input"})

        conn
        |> send_resp(404, body)
    end
  end

  def user_employee_code(conn, %{"employee_code" => employee_code}) do
    user = Accounts.user_by_employee_code(employee_code)
    render(conn, "show_logging.json", user: user)
  end

  @doc """
  get projects assigned to the user
  """

  def user_projects(conn, %{"employee_code" => employee_code}) do
    case Accounts.get_by_employee_code(employee_code) do
      {:ok, user} ->
        user = Accounts.user_projects!(user.id)
        render(conn, "show_projects.json", user: user)

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "user not found"})

        conn
        |> send_resp(40, body)
    end
  end

  # gets the reset code for the user

  def get_reset_key(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "code.json", user: user)
  end

  # Get list of active user accounts

  def active_users(conn, _params) do
    users = Accounts.active_users()
    render(conn, "index.json", users: users)
  end

  # Get list of deactivated or not active users

  def terminated_users(conn, _params) do
    users = Accounts.terminated_users()
    render(conn, "index.json", users: users)
  end

  # Sign up or register user

  def signup(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register(user_params) do
      conn
      |> put_status(:created)
      |> render("show_new.json", user: user)
    end
  end

  # Sign in

  def signin(conn, %{"employee_code" => employee_code, "pass" => pass}) do
    case Accounts.user_authentication(employee_code, pass) do
      {:ok, user} ->
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {120, :minute})

        conn = Guardian.Plug.sign_in(conn, user)

        conn
        |> put_resp_cookie("token", access_token)
        |> put_resp_cookie("prm", user.employee_code)
        |> put_resp_cookie("user", user.name)
        |> put_status(:created)
        |> render("token.json", access_token: access_token)

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "employee code or password incorrect", status: 401})

        conn
        |> send_resp(401, body)
    end
  end

  # Sign in for admins only used if there's a change in records

  def admin_login(conn, %{"employee_code" => employee_code, "pass" => pass}) do
    case Accounts.admin_authentication(employee_code, pass) do
      {:ok, user} ->
        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {120, :minute})

        conn = Guardian.Plug.sign_in(conn, user)

        conn
        |> put_resp_cookie("token", access_token)
        |> put_resp_cookie("prm", user.employee_code)
        |> put_resp_cookie("user", user.name)
        |> put_status(:created)
        |> render("token.json", access_token: access_token)

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "employee code or password incorrect", status: 401})

        conn
        |> send_resp(401, body)
    end
  end

  # Password update or change

  def password_update(conn, %{
        "employee_code" => employee_code,
        "password_reset" => password_reset,
        "user" => user_params
      }) do
    case Accounts.update_password_user_check(employee_code, password_reset) do
      {:ok, user} ->
        user = Accounts.get_user!(user.id)

        with {:ok, %User{} = user} <- Accounts.update_password(user, user_params) do
          render(conn, "show.json", user: user)
        end

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "please check input"})

        conn
        |> send_resp(401, body)
    end
  end

  #  generate reset key

  def reset_key(conn, %{"employee_code" => employee_code, "user" => user_params}) do
    case Accounts.get_by_employee_code(employee_code) do
      {:ok, user} ->
        user = Accounts.get_user!(user.id)

        with {:ok, %User{} = user} <- Accounts.add_reset_key(user, user_params) do
          conn
          |> render("show.json", user: user)
        end

      {:error, :unauthorized} ->
        body = Jason.encode!(%{error: "error input"})

        conn
        |> send_resp(401, body)
    end
  end

  # Controls that require authorization

  # Log out control
  def logout(conn, _params) do
    conn
    |> delete_resp_cookie("token")
    |> delete_resp_cookie("prm")
    |> delete_resp_cookie("user")
    |> put_status(200)
    |> text("Logged out ")
  end

  # update user

  def update_user_details(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # mapping user

  def mapping_user(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.map_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # terminate user account

  def terminate_user(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.terminate_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # activate user account

  def activate_user(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.activate_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  # Delete User Account 

  def delete_user(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.delete_user(user) do
      conn
      |> put_status(200)
      |> text("team deleted successfully")
    end
  end
end
