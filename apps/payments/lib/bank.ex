defmodule Payments.Bank do
  @moduledoc false

  use GenServer

  require Logger

  alias Payments.Bank.Ledger
  alias Payments.Payment

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__})
  end

  def init(_args) do
    Logger.info("  💵 Payments - 🏦 Bank - Start service")
    {:ok, Ledger.new()}
  end

  def handle_call({:pay, order_uuid, amount}, _from, ledger) do
    [order_uuid: order_uuid, amount: amount]
    |> Payment.new()
    |> tap(fn payment ->
      Logger.info("🏦 Bank  - ⬅️  Validating payment for order #{payment.order_uuid}")
    end)
    |> then(fn %Payment{order_uuid: order_uuid} = payment ->
      status = if String.starts_with?(order_uuid, "a"), do: :rejected, else: :accepted
      %{payment | status: status}
    end)
    |> tap(fn
      %Payment{status: :accepted} = payment ->
        Logger.info("🏦 Bank  - ✅ Payment accepted for order #{payment.order_uuid}")

      %Payment{} = payment ->
        Logger.info("🏦 Bank  - ❌ Validate payment for order #{payment.order_uuid}")
    end)
    |> case do
      %Payment{status: :accepted} = payment ->
        {:ok, ledger} = Ledger.add_payment(ledger, payment)
        {:reply, {:ok, payment.uuid}, ledger}

      %Payment{status: status} ->
        {:reply, {:error, status}, ledger}
    end
  end
end
