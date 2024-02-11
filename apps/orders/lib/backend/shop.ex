defmodule Orders.Shop do
  @moduledoc false

  use GenServer

  require Logger

  alias Orders.Order

  @doc "Start the shop"
  @spec start_link(any()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Logger.info("└ 🏪 Orders / Backend - 🛒 Shop - Start service")
    {:ok, %{count: 0}}
  end

  @doc "Send an order to the shop"
  @spec send_order(Order.t()) ::
          {:accepted, Order.t()} | {:refused, Order.t()} | {:unavailable, Order.t()}
  def send_order(%Order{} = order) do
    GenServer.call(__MODULE__, {:send_order, order})
  catch
    :exit, _ -> {:unavailable, order}
  end

  def send_order(_), do: {:error, :invalid_order}

  @impl true
  def handle_call({:send_order, %Order{} = order}, _from, %{count: count} = state) do
    Logger.info("🛒 Shop  \t| 🧾 New order #{order.uuid} received (#{count} orders today)")

    response =
      with {:ok, _} <- stock_available?(order),
           :ok <- Logger.info("🛒 Shop \t| ➡️  Stock available for order #{order.uuid}"),
           {:ok, payment_uuid} <- pay_order(order),
           :ok <- Logger.info("🛒 Shop \t| ➡️  Order #{order.uuid} payed #{payment_uuid}") do
        Logger.info("🛒 Shop \t| ✅ Order #{order.uuid} accepted\n")
        {:accepted, order}
      else
        {:error, error} ->
          Logger.info("🛒 Shop \t| ❌ Order #{order.uuid} due to #{error}\n")
          {:refused, order}
      end

    {:reply, response, %{state | count: count + 1}}
  end

  @doc "Send a payment request to the bank"
  @spec pay_order(Order.t()) :: {:ok, String.t()} | {:error, :payment_failed}
  def pay_order(%Order{} = order) do
    GenServer.call({:global, Payments.Bank}, {:pay, order.uuid, order.price})
  end

  @doc "Check if the stock is available"
  @spec stock_available?(Order.t()) :: {:ok, integer()} | {:error, :no_items_left}
  def stock_available?(%Order{} = order) do
    GenServer.call({:global, Stocks.Warehouse}, {:remove_item, order.uuid, order.items})
  end
end
