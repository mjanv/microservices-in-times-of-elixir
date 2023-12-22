defmodule Stocks.Stock do
  @moduledoc false

  require Logger

  def is_stock_available?(order_uuid, node) do
    {Stocks.TaskSupervisor, node}
    |> Task.Supervisor.async(__MODULE__, :do_is_stock_available, [order_uuid])
    |> Task.await()
  end

  def do_is_stock_available(order_uuid) do
    Logger.info("📦 Stock - ⬅️  Check stock for order #{order_uuid}")
    Logger.info("📦 Stock - ✅ Order #{order_uuid} accepted")
    {:ok, 5}
  end
end
