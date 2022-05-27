defmodule KrystalMathApi.Operations.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias KrystalMathApi.Accounts.User
  alias KrystalMathApi.Operations.{Team, TaskStatus, Environment}

  schema "tasks" do
    field :name, :string
    belongs_to :team, Team, foreign_key: :team_id
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :task_status, TaskStatus, foreign_key: :task_status_id
    belongs_to :environment, Environment, foreign_key: :environment_id
    field :task_comment, :string
    field :kickoff_date, :naive_datetime
    field :due_date, :naive_datetime
    field :active, :boolean, default: true
    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :name,
      :team_id,
      :user_id,
      :task_status_id,
      :environment_id,
      :task_comment,
      :due_date,
      :kickoff_date,
      :active
    ])
    |> validate_required([
      :name,
      :team_id,
      :user_id,
      :task_status_id,
      :environment_id,
      :task_comment,
      :due_date
    ])
    |> validate_length(:task_comment, max: 200)
    |> unique_constraint(:name)
  end

  def dev_changeset(task, attrs) do
    task
    |> cast(attrs, [
      :task_status_id,
      :active
    ])
    |> validate_required([
      :task_status_id
    ])
  end

  def de_activation_changeset(task, attrs) do
    task
    |> cast(attrs, [
      :name,
      :team_id,
      :user_id,
      :task_status_id,
      :environment_id,
      :task_comment,
      :due_date,
      :kickoff_date,
      :active
    ])
    |> put_change(:active, false)
  end

  def activation_changeset(task, attrs) do
    task
    |> cast(attrs, [
      :name,
      :team_id,
      :user_id,
      :task_status_id,
      :environment_id,
      :task_comment,
      :due_date,
      :kickoff_date,
      :active
    ])
    |> put_change(:active, true)
  end
end
