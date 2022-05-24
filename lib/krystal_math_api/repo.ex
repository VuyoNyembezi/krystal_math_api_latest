defmodule KrystalMathApi.Repo do
  use Ecto.Repo,
    otp_app: :krystal_math_api,
    adapter: Ecto.Adapters.Postgres
end
