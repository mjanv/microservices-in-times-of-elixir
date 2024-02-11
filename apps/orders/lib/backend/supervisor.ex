defmodule Orders.Backend.Supervisor do
  @moduledoc """
  Backend supervisor

  The supervisor is responsible to start processes for the backend service
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
    # Logger.info("  🏪 Orders - Backend - Start service")

    children = [
      Orders.Shop
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
