defmodule KrystalMathApi.Operations.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias KrystalMathApi.Accounts.User
  alias KrystalMathApi.Operations.Task

schema "teams" do
  has_many :task, Task
  has_many :users, User
  field :name, :string
  belongs_to :team_lead, User, foreign_key: :team_lead_id  
  field :is_active, :boolean, default: true
end
def changeset(team, attrs) do
  team
  |> cast(attrs, [:name, :team_lead_id, :is_active])
  |> validate_required([:name])
  |> unique_constraint(:name)
end
def deactivate_changeset(team, attrs) do
  team
  |> cast(attrs, [:name, :team_lead_id, :is_active ])
  |> put_change(:is_active, false)
end

def activate_changeset(team, attrs) do
  team
  |> cast(attrs, [:name, :team_lead_id, :is_active ])
  |> put_change(:is_active, true)
end

end
