import Config

if config_env() == :prod do
  config :kernel,
    distributed: [
      {:orders, 1_000, [:"frontend@127.0.0.1"]},
      {:payments, 1_000, [:"backend@127.0.0.1", :"frontend@127.0.0.1"]},
      {:stocks, 1_000, [:"backend@127.0.0.1", :"frontend@127.0.0.1"]}
    ],
    sync_nodes_optional: [:"frontend@127.0.0.1", :"backend@127.0.0.1"],
    sync_nodes_timeout: 1_000
end
