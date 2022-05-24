import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :krystal_math_api, KrystalMathApi.Repo,
  username: "postgres",
  password: "12345",
  hostname: "localhost",
  database: "krystal_math_api_2#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :krystal_math_api, KrystalMathApiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "shY0h+nyDMGciG4mqr/MMuriZbDF40aquMqlAZlWAaSPCk182QMJjKWat3wVFl96",
  server: false

# In test we don't send emails.
config :krystal_math_api, KrystalMathApi.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
