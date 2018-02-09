defmodule Healthlocker.Mixfile do
  use Mix.Project

  def project do
    [app: :healthlocker,
     version: "1.0.3",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Healthlocker, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 1.0"},
      {:bamboo, "~> 0.7"},
      {:bamboo_smtp, "~> 1.2.1"},
      {:comeonin, "~> 3.0"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.7.2", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.1"},
      {:ecto_factory, "~> 0.0.6"},
      {:faker, "~> 0.7"},
      {:gettext, "~> 0.11"},
      {:html_sanitize_ex, "~> 1.0"},
      {:mock, "~> 0.2.0", only: :test, runtime: false},
      {:oxleas_adhd, in_umbrella: true},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev, runtime: false},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug, "~>1.3.5", override: true},
      {:postgrex, ">= 0.0.0"},
      {:segment, github: "tonydaly/analytics-elixir"},
      {:timex, "~> 3.0"},
      {:wallaby, "~> 0.16.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
