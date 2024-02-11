import Config

if config_env() == :prod do
  config :kernel,
    distributed: [
      {:orders, 1_000, [:"a@127.0.0.1"]},
      {:payments, 1_000, [:"b@127.0.0.1", :"a@127.0.0.1"]},
      {:stocks, 1_000, [:"b@127.0.0.1", :"a@127.0.0.1"]}
    ],
    sync_nodes_optional: [:"a@127.0.0.1", :"b@127.0.0.1"],
    sync_nodes_timeout: 1_000

  config :libcluster,
    topologies: [
      local: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]
end
