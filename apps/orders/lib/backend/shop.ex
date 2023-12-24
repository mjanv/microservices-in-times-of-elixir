defmodule Orders.Shop do
  @moduledoc false

  use GenServer

  require Logger

  alias Orders.Order

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    Logger.info("  🏪 Orders - 🌐 Backend - 🛒 Shop - Start service")
    {:ok, %{count: 0}}
  end

  def send_order(%Order{} = order) do
    :ok = GenServer.cast(Orders.Shop, {:send_order, order})
    {:ok, order}
  end

  def send_order(_), do: {:error, :invalid_order}

  def handle_cast({:send_order, %Order{} = order}, %{count: count} = state) do
    Logger.info("🛒 Shop  - 🧾 Order n°#{order.uuid} received (#{count})")

    with {:ok, _} <- stock_available?(order),
         :ok <- Logger.info("🛒 Shop  - ➡️  Stock available for order #{order.uuid}"),
         {:ok, payment_uuid} <- pay_order(order),
         :ok <- Logger.info("🛒 Shop  - ➡️  Order #{order.uuid} payed #{payment_uuid}") do
      Logger.info("🛒 Shop  - ✅ Order #{order.uuid} accepted\n")
    else
      {:error, error} ->
        Logger.info("🛒 Shop  - ❌ Order #{order.uuid} due to #{error}\n")
    end

    {:noreply, %{state | count: count + 1}}
  end

  defp pay_order(%Order{} = order) do
    GenServer.call({:global, Payments.Bank}, {:pay, order.uuid, order.price})
  end

  def stock_available?(%Order{} = order) do
    Stocks.stock_available?(order.uuid, Node.self())
  end
end
