import Config

if config_env() == :prod do
  config :libcluster,
    topologies: [
      local: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]
end
