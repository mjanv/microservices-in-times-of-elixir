defmodule Stocks.Application do
  @moduledoc """
  Stocks service
  """

  use Application

  require Logger

  @impl true
  def start(type, _args) do
    case type do
      :normal -> Logger.info("📦 Stocks - Start service")
      {:failover, node} -> Logger.info("📦 Stocks - Failover service from #{inspect(node)}")
      {:takeover, node} -> Logger.info("📦 Stocks - Takeover service from #{inspect(node)}")
    end

    children = [
      # {Cluster.Supervisor, [topologies(), [name: Stocks.Cluster]]},
      Stocks.Warehouse
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Stocks.Supervisor)
  end

  @impl true
  def stop(_state) do
    Logger.info("📦 Stocks - Stop service")
    :ok
  end

  # defp topologies, do: Application.get_env(:libcluster, :topologies)
end
