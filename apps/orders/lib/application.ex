defmodule Orders.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("🏪 Orders - Start service")

    children = [
      Orders.Frontend.Supervisor,
      Orders.Backend.Supervisor,
      {Cluster.Supervisor, [topologies(), [name: Orders.Cluster]]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Orders.Supervisor)
  end

  defp topologies, do: Application.get_env(:libcluster, :topologies)
end
