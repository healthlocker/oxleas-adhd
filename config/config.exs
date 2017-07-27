# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :oxleas_adhd,
  ecto_repos: [OxleasAdhd.Repo]

# Configures the endpoint
config :oxleas_adhd, OxleasAdhd.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sOmxvGd7TnkbuxIzGUdiaB16GdR2uhzDM+aMVfsnE3PYQ/feMavPBiIWy8MtK9jU",
  render_errors: [view: OxleasAdhd.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OxleasAdhd.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
