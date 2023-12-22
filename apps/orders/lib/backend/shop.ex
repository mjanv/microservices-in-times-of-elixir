defmodule Orders.Shop do
  @moduledoc false

  use GenServer

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    Logger.info("  🏪 Orders - 🌐 Backend - 🛒 Shop - Start service")
    {:ok, %{count: 0}}
  end

  def new_order do
    uuid = UUID.uuid4()
    :ok = GenServer.cast(Orders.Shop, {:new_order, uuid})
    {:ok, uuid}
  end

  def handle_cast({:new_order, order_uuid}, %{count: count} = state) do
    Logger.info("🛒 Shop  - 🧾 Order n°#{order_uuid} received (#{count})")

    with {:ok, _} <- is_stock_available?(order_uuid),
         :ok <- Logger.info("🛒 Shop  - ➡️  Stock available for order #{order_uuid}"),
         {:ok, {_, payment_uuid}} <- pay_order(order_uuid),
         :ok <- Logger.info("🛒 Shop  - ➡️  Order #{order_uuid} payed #{payment_uuid}") do
      Logger.info("🛒 Shop  - ✅ Order #{order_uuid} accepted\n")
    else
      {:error, error} ->
        Logger.info("🛒 Shop  - ❌ Order #{order_uuid} due to #{error}\n")
    end

    {:noreply, %{state | count: count + 1}}
  end

  defp pay_order(order_uuid) do
    GenServer.call({:global, Payments.Bank}, {:pay, order_uuid})
  end

  def is_stock_available?(order_uuid) do
    Stocks.Stock.is_stock_available?(order_uuid, Node.self())
  end
end
