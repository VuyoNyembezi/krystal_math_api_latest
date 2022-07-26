defmodule KrystalMathApi.Accounts do
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Accounts.{User, Role}
  alias KrystalMathApi.Operations.Team

  @doc """
  search user account name,surname or employee Code
  """
  def user_account_name_search(search_term) do
    search_name = "%#{search_term}%"

    results =
      from(u in User,
        where:
          like(u.name, ^search_name) or like(u.last_name, ^search_name) or
            like(u.employee_code, ^search_name)
      )

    Repo.all(results)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  search user account name,surname or employee Code
  """
  def terminated_user_account_name_search(search_term) do
    search_name = "%#{search_term}%"

    results =
      from(u in User,
        where:
          like(u.name, ^search_name) or like(u.last_name, ^search_name) or
            like(u.employee_code, ^search_name),
        where: u.is_active == false
      )

    Repo.all(results)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  search user account name,surname or employee Code and Role
  """

  def user_account_role_search(role_id, search_term) do
    search_name = "%#{search_term}%"

    results =
      from(u in User,
        where:
          like(u.name, ^search_name) or like(u.employee_code, ^search_name) or
            like(u.last_name, ^search_name),
        where: u.user_role_id == ^role_id and u.is_active == true
      )

    Repo.all(results)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  search team user account name,surname or employee Code 
  """
  def user_account_team_search(team_id, search_term) do
    search_name = "%#{search_term}%"

    results =
      from(u in User,
        where:
          like(u.name, ^search_name) or like(u.employee_code, ^search_name) or
            like(u.last_name, ^search_name),
        where: u.team_id == ^team_id and u.is_active == true
      )

    Repo.all(results)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  this function is called when the api is render for the 1st Time
  get admin profile
  """

  def admin_get(employee_code) do
    case Repo.get_by(User, employee_code: employee_code, is_active: true, is_admin: true) do
      nil ->
        {:error, :unauthorized}

      user ->
        user
        |> Repo.preload([:team, :user_role])

        {:ok, user}
    end
  end

  @doc """
  select all users from the database
  """

  def list_all_users do
    User
    |> Repo.all()
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  select user by id from the database
  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  get team members
  """

  def team_members!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(:users)
  end

  def user_jobs!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:project)
  end

  @doc """
  get user projects
  """

  def user_projects!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload([:team, :project])
  end

  @doc """
  get active memebers
  """
  def active_users do
    query = from(u in User, where: u.is_active == true)

    Repo.all(query)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  get deactivated or terminated memebers
  """

  def terminated_users do
    query = from(u in User, where: u.is_active == false)

    Repo.all(query)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  get users By Roles
  """
  def system_users_roles(user_role) do
    default_role = 2
    query = from(u in User, where: u.is_active == true and u.user_role_id == ^user_role)

    Repo.all(query)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  Checks the employee code if its for an admin account

  """
  def admin_check(employee_code) do
    case Repo.get_by(User, employee_code: employee_code, is_active: true, is_admin: true) do
      nil ->
        {:error, :unauthorized}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Updates user Information Mapping, Termination, new roles

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.map_user(attrs)
    |> Repo.update()
  end

  # map user between teams
  def map_user(%User{} = user, attrs) do
    user
    |> User.map_user(attrs)
    |> Repo.update()
  end

  # terminate user
  def terminate_user(%User{} = user, attrs) do
    user
    |> User.terminate_user_changeset(attrs)
    |> Repo.update()
  end

  # activate user
  def activate_user(%User{} = user, attrs) do
    user
    |> User.activate_user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  validates the employee code and password reset key stored
  """
  def update_password_user_check(employee_code, password_reset) do
    case Repo.get_by(User,
           employee_code: employee_code,
           password_reset: password_reset,
           is_active: true
         ) do
      nil ->
        {:error, :unauthorized}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Updates the password of the user
  """
  def update_password(%User{} = user, attrs) do
    user
    |> User.update_password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  adds the reset key
  """
  def add_reset_key(%User{} = user, attrs) do
    user
    |> User.reset_key_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  select user by employee code
  """
  def get_by_employee_code(employee_code) when is_binary(employee_code) do
    case Repo.get_by(User, employee_code: employee_code, is_active: true) do
      nil ->
        {:error, :unauthorized}

      user ->
        {:ok, user}
    end
  end

  def user_by_employee_code(employee_code) do
    User
    |> Repo.get_by(employee_code: employee_code)
    |> Repo.preload([:team, :user_role])
  end

  @doc """
  user sign up/ register user
  """

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  user LOGIN
  """
  def user_authentication(employee_code, pass) do
    case get_by_employee_code(employee_code) do
      {:ok, user} ->
        case validate_password(pass, user.password) do
          true ->
            {:ok, user}

          false ->
            {:error, :unauthorized}
        end

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end

  @doc """
    validates admin for major chages i.e deleting project, terminating user , updating user details
  """
  def admin_authentication(employee_code, pass) do
    case admin_check(employee_code) do
      {:ok, user} ->
        case validate_password(pass, user.password) do
          true ->
            {:ok, user}

          false ->
            {:error, :unauthorized}
        end

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end

  # validates password

  defp validate_password(pass, password) do
    Pbkdf2.verify_pass(pass, password)
  end

  @doc """
  deletes the user account from the system

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  returns a `%Ecto.Changeset{}` for tracking user changes.

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
