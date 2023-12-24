defmodule Stocks.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("📦 Stocks - Start service")

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
