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
      {Task.Supervisor, name: Stocks.TaskSupervisor},
      Stocks.Warehouse
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Stocks.Supervisor)
  end

  @impl true
  def stop(_state) do
    Logger.info("📦 Stocks - Stop service")
    :ok
  end
end
