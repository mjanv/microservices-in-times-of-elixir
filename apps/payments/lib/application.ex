defmodule Payments.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("💵 Payments - Start service")

    children = [
      Payments.Bank,
      {Cluster.Supervisor, [topologies(), [name: Payments.Cluster]]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Payments.Supervisor)
  end

  defp topologies, do: Application.get_env(:libcluster, :topologies)
end
