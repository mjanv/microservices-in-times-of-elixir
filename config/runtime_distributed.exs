import Config

if config_env() == :prod do
  config :libcluster,
    topologies: [
      local: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]

  config :kernel,
    distributed: [
      {:orders, 500, [:"a@127.0.0.1"]},
      {:payments, 500, [:"b@127.0.0.1", :"a@127.0.0.1"]},
      {:stocks, 500, [:"b@127.0.0.1", :"a@127.0.0.1"]}
    ],
    sync_nodes_optional: [:"a@127.0.0.1", :"b@127.0.0.1"],
    sync_nodes_timeout: 500
end
