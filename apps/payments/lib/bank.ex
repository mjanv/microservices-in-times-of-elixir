defmodule Payments.Bank do
  @moduledoc false

  use GenServer

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__})
  end

  def init(args) do
    Logger.info("  💵 Payments - 🏦 Bank - Start service")
    {:ok, args}
  end

  def handle_call({:pay, order_uuid}, _from, state) do
    Logger.info("🏦 Bank  - ⬅️  Validating payment for order #{order_uuid}")

    response =
      order_uuid
      |> String.starts_with?("a")
      |> case do
        true ->
          Logger.info("🏦 Bank  - ❌ Validate payment for order #{order_uuid}")
          {:error, :payment_failed}

        false ->
          Logger.info("🏦 Bank  - ✅ Validate payment for order #{order_uuid}")
          {:ok, UUID.uuid4()}
      end

    {:reply, response, state}
  end

  def pay(order_uuid) do
    GenServer.call({:global, __MODULE__}, {:pay, order_uuid})
  end
end
