defmodule Orders.Application do
  @moduledoc """
  Orders application
  """

  use Application

  require Logger

  @impl true
  def start(type, _args) do
    case type do
      :normal -> Logger.info("🏪 Orders - Start service")
      {:failover, node} -> Logger.info("🏪 Orders - Failover service from #{inspect(node)}")
      {:takeover, node} -> Logger.info("🏪 Orders - Takeover service from #{inspect(node)}")
    end

    children = [
      Orders.Frontend.Supervisor,
      Orders.Backend.Supervisor,
      {Cluster.Supervisor, [topologies(), [name: Orders.Cluster]]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Orders.Supervisor)
  end

  @impl true
  def stop(_state) do
    Logger.info("🏪 Orders - Stop service")
    :ok
  end

  defp topologies, do: Application.get_env(:libcluster, :topologies)
end
