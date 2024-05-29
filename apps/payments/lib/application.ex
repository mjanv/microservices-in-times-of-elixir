defmodule Payments.Application do
  @moduledoc """
  Payments service
  """

  use Application

  require Logger

  @impl true
  def start(type, _args) do
    case type do
      :normal -> Logger.info("💵 Payments - Start service")
      {:failover, node} -> Logger.info("💵 Payments - Failover service from #{inspect(node)}")
      {:takeover, node} -> Logger.info("💵 Payments - Takeover service from #{inspect(node)}")
    end

    children = [
      {Cluster.Supervisor, [topologies(), [name: Payments.Cluster]]},
      Payments.Bank
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Payments.Supervisor)
  end

  @impl true
  def stop(_state) do
    Logger.info("💵 Payments - Stop service")
    :ok
  end

  defp topologies, do: Application.get_env(:libcluster, :topologies)
end
