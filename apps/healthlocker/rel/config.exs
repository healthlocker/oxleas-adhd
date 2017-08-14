# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"?J.<C_D^;nAeubhv?qoXqFK_=;y`5c@yN_`ttp)@4QI7:Sm2lTcnG{lD(G6Lu&[<"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"dAfW2?q9h{m(zcV!3qWp>.c;bn_D;PsJp3?SK&56imsT;s%mnv2f1|dVTmtM@c9O"
  set vm_args: "rel/vm.args"
  set sys_config: nil
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :healthlocker do
  set version: current_version(:healthlocker)
  set applications: [
    :runtime_tools
  ]
end