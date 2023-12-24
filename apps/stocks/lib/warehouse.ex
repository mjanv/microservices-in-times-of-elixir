defmodule Stocks.Warehouse do
  @moduledoc false

  require Logger

  use GenServer

  alias Stocks.Stock

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    Logger.info("📦 Warehouse - Init")
    Process.send_after(self(), :restock, 5_000)
    {:ok, %Stock{items: 10}}
  end

  def stock_available?(order_uuid, node) do
    {Stocks.TaskSupervisor, node}
    |> Task.Supervisor.async(fn ->
      GenServer.call(__MODULE__, {:remove_item, order_uuid})
    end)
    |> Task.await()
  end

  def handle_call({:remove_item, order_uuid}, _from, stock) do
    Logger.info("📦 Warehouse - ⬅️  Remove item from stock")

    stock
    |> Stock.remove_item()
    |> tap(fn
      {:ok, _} ->
        Logger.info("📦 Stock - ⬅️  Check stock for order #{order_uuid}")
        Logger.info("📦 Stock - ✅ Order #{order_uuid} accepted")

      {:error, _} ->
        Logger.info("📦 Stock - ⬅️  Check stock for order #{order_uuid}")
        Logger.info("📦 Stock - ❌ Order #{order_uuid} rejected")
    end)
    |> tap(fn _ -> Process.send_after(self(), :restock, 100) end)
    |> then(fn
      {:ok, stock} -> {:reply, {:ok, stock}, stock}
      {:error, _} -> {:reply, {:error, :no_items_left}, stock}
    end)
  end

  def handle_info(:restock, stock) do
    {:ok, stock} =
      if stock.items < 5 do
        Logger.info("📦 Warehouse - 🔄 Restock 10 new items")
        Stock.add_items(stock, items: 10)
      else
        {:ok, stock}
      end

    {:noreply, stock}
  end
end
