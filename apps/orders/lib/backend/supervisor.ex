defmodule Orders.Backend.Supervisor do
  @moduledoc false

  use Supervisor

  require Logger

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    Logger.info("  🏪 Orders - 🌐 Backend - Start service")

    children = [
      Orders.Shop
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
