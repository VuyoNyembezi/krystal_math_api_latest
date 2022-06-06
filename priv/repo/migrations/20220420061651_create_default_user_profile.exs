defmodule KrystalMathApi.Repo.Migrations.CreateDefaultUserProfile do
  use Ecto.Migration
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Accounts.{User,Role}
  alias KrystalMathApi.Operations.Team
  import Ecto.Changeset
  def up do
    #SystemRoles
    Repo.insert(%Role{name: "Admin"})
    Repo.insert(%Role{name: "User"})
    Repo.insert(%Role{name: "Manager"})
    Repo.insert(%Role{name: "Team Leader"})
    Repo.insert(%Role{name: "SDM"})
    Repo.insert(%Role{name: "PM"})
    #default Team
    Repo.insert(%Team{name: "TBA"})

    #default User Profiles
    Repo.insert(%User{name: "admin",last_name: "admin",employee_code: "admin", email: "admin@gmail.com",password: "@Administrator",password_reset: "@RESET_KEY",team_id: 1, user_role_id: 1,is_active: true, is_admin: true}, on_conflict: :replace_all, conflict_target: :employee_code)
    Repo.insert(%User{name: "TBA",last_name: "TBA",employee_code: "BT0000", email: "defaultuser@gmail.com",password: "@@@",password_reset: "@RESET_KEYTBA",team_id: 1, user_role_id: 2,is_active: true, is_admin: false}, on_conflict: :replace_all, conflict_target: :employee_code)
    Repo.insert(%User{name: "TBA",last_name: "TBA",employee_code: "BT@#", email: "defaultpm@gmail.com",password: "@@@",password_reset: "@RESET_KEYTBAPM",team_id: 1, user_role_id: 6,is_active: true, is_admin: false}, on_conflict: :replace_all, conflict_target: :employee_code)

    Repo.update_all(Team, set: [team_lead_id: 2])

  end

  def down do
     execute """
    delete  from teams cascade;
    """
    execute """
    delete  from user_roles cascade;
    """
    execute """
    delete  from users cascade;
    """

  end
end
