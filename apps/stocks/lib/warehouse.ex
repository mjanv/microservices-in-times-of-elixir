defmodule Stocks.Warehouse do
  @moduledoc false

  require Logger

  use GenServer

  alias Stocks.Stock

  @doc "Start the warehouse"
  @spec start_link(any()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__})
  end

  @impl true
  def init(_args) do
    Logger.info("└ 📦 Stocks - 🏭 Warehouse - Start service")
    {:ok, %Stock{items: 10}}
  end

  @doc "Check if the stock is available"
  @spec stock_available?(String.t(), integer()) ::
          {:ok, integer()} | {:error, :no_items_left}
  def stock_available?(order_uuid, items) do
    GenServer.call(__MODULE__, {:remove_item, order_uuid, items})
  end

  @impl true
  def handle_call({:remove_item, order_uuid, items}, _from, stock) do
    stock
    |> tap(fn _ -> Logger.info("🏭 Warehouse \t| ⬅️  Can I remove #{items} items from stock ?") end)
    |> Stock.remove_items(items: items)
    |> tap(fn
      {:ok, _} -> Logger.info("🏭 Warehouse \t| ✅ We have enough stock for order #{order_uuid}")
      {:error, _} -> Logger.info("🏭 Warehouse \t| ❌ No stock available for order #{order_uuid}")
    end)
    |> tap(fn _ -> Process.send_after(self(), :restock, 100) end)
    |> then(fn
      {:ok, stock} -> {{:ok, stock.items}, stock}
      {:error, stock} -> {{:error, :no_items_left}, stock}
    end)
    |> then(fn {response, stock} -> {:reply, response, stock} end)
  end

  @impl true
  def handle_info(:restock, stock) do
    stock
    |> Stock.restock(threshold: 5, new_items: 10)
    |> tap(fn
      {:ok, _} -> Logger.info("🏭 Warehouse - 🔄 Restock 10 new items")
      {:error, _} -> :ok
    end)
    |> then(fn {_, stock} -> {:noreply, stock} end)
  end
end
