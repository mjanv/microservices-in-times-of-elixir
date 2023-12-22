import Config

config :libcluster,
  topologies: [
    local: [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: [
          :"frontend@127.0.0.1",
          :"backend@127.0.0.1"
        ]
      ]
    ]
  ]
