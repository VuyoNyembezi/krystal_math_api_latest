defmodule KrystalMathApi.Operations.TaskStatus do
  use Ecto.Schema
  import Ecto.Changeset
  alias KrystalMathApi.Operations.Task

  schema "task_statuses" do
    has_many :task, Task
    field :name, :string
    field :level, :string, null: true
  end

  def changeset(task_status, attrs) do
    task_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
