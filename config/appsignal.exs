use Mix.Config

config :appsignal, :config,
  active: true,
  name: "Oxleas",
  push_api_key: System.get_env("APPSIGNAL_PUSH_API_KEY"),
  env: Mix.env
