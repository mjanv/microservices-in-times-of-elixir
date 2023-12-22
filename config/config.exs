import Config

config :logger, :console, format: "$message\n"

import_config "#{config_env()}.exs"
