import Config

if config_env() == :prod do
  config :libcluster,
    topologies: []
end
