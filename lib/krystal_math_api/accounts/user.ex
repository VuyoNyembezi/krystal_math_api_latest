defmodule KrystalMathApi.Accounts.User do
  use Ecto.Schema
import Ecto.Changeset
alias KrystalMathApi.Accounts.{User,Role}
alias  KrystalMathApi.Operations.{Team, Task}
schema "users" do
field :employee_code, :string
field :name, :string
field :last_name, :string
field :email, :string
field :password, :string
field :pass, :string, virtual: true
belongs_to :team, Team, foreign_key: :team_id
field :is_active, :boolean, default: true
field :is_admin, :boolean, default: false
field :password_reset, :string
has_many :task, Task
belongs_to :user_role, Role, foreign_key: :user_role_id

timestamps()
end

def changeset(%User{} = user, attrs) do
  user
  |> cast(attrs, [:employee_code, :name, :last_name,:email, :pass, :team_id, :is_admin,:user_role_id ])
  |> validate_required([:employee_code, :name, :last_name, :email, :pass, :team_id])
  |> unique_constraint([:employee_code])
  |> unique_constraint([:email])
  |> validate_length(:pass, min: 6)
  |> validate_format(:email, ~r/\S+@\S+\.\S+/)
  |> encrypt_password()
end

# changeset for mapping users
def map_user(%User{} = user, attrs) do
  user
  |> cast(attrs, [:team_id, :user_role_id,:is_admin ])
  |> validate_required([:team_id])
end

# changeset to generate reset key
def reset_key_changeset(%User{} = user, attrs) do
  user
  |> cast(attrs, [:employee_code ,:password_reset ])
  |> validate_required([:employee_code])
  change(user,
  password_reset: random_key())
end

#random key generator
defp random_key do
  "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%^&*()_+=[]"
  |> String.codepoints
  |> Enum.take_random(10)
  |> Enum.join
end


#changeset to update password
def update_password_changeset(%User{} = user, attrs) do
  user
  |> cast(attrs, [:pass, :password_reset])
  |> validate_required([:pass])
  |> validate_length(:pass, min: 6)
  |> put_change(:password_reset, nil)
  |> encrypt_new_password()
end

# Terminate user
def terminate_user_changeset(%User{} = user, attrs) do
  user
  |> cast(attrs, [:employee_code, :name, :last_name,:email, :pass, :team_id, :is_admin, :user_role_id, :is_active ])
  |> put_change(:is_active, false)
end
# Activate user
def activate_user_changeset(%User{} = user, attrs) do
  user
  |> cast(attrs, [:employee_code, :name, :last_name,:email, :pass, :team_id, :is_admin, :user_role_id, :is_active ])
  |> put_change(:is_active, true)
end

#function to encrypt password
def encrypt_password(changeset) do
  case changeset do
    %Ecto.Changeset{valid?: true, changes: %{pass: mypass}} ->
      put_change(changeset, :password, Pbkdf2.hash_pwd_salt(mypass))
    _->
        changeset
  end
end

##encrypts password for password change

def encrypt_new_password(changeset) do
  case changeset do
    %Ecto.Changeset{valid?: true, changes: %{pass: mypass}} ->
      put_change(changeset, :password, Pbkdf2.hash_pwd_salt(mypass))
    _->
        changeset
  end
end

end
