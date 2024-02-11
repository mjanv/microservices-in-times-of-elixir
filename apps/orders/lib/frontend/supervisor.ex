defmodule Orders.Frontend.Supervisor do
  @moduledoc """
  Frontend supervisor

  The supervisor is responsible to start processes for the frontend service
  """

  use Supervisor

  require Logger

  @doc "Start the supervisor"
  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    # Logger.info("  🏪 Orders / Frontend - Start service")
    Logger.info("├ 🏪 Orders / Frontend - 🌐 Webserver - Start service")

    children = [
      {Bandit, plug: Orders.Frontend.Router, startup_log: false}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
