use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, App.Endpoint,
  http: [port: 4001],
  server: true

config :app, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :app, App.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :app, App.ReadOnlyRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "epjs_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :app, :analytics, App.Analytics.Local

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :appsignal, :config, active: false

config :wallaby, screenshot_on_failure: true
config :wallaby, phantomjs_args: "--proxy-type=none"

config :app, :environment, :test
