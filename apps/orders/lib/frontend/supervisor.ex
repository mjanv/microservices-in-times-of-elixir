defmodule Orders.Frontend.Supervisor do
  @moduledoc false

  use Supervisor

  require Logger

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Logger.info("  🏪 Orders - 🌐 Frontend - Start service")

    children = [
      {Bandit, plug: Orders.Frontend.Router, startup_log: false}
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
