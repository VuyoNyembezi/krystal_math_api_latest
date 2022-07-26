defmodule KrystalMathApi.Operations.Environment do
  use Ecto.Schema
  import Ecto.Changeset
  alias KrystalMathApi.Operations.Task
  alias KrystalMathApi.Operations.Environment

  schema "environments" do
    has_many :task, Task
    field :name, :string
  end

  def changeset(%Environment{} = environment, attrs) do
    environment
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
