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
    Payment.new(order_uuid: order_uuid, amount: amount)
    |> pay(ledger)
    |> then(fn {response, ledger} -> {:reply, response, ledger} end)
  end

  def pay(%Payment{} = payment, %Ledger{} = ledger) do
    payment
    |> tap(&log_payment/1)
    |> then(&payment_accepted?/1)
    |> tap(&log_payment_status/1)
    |> then(&add_payment(&1, ledger))
  end

  def payment_accepted?(%Payment{order_uuid: order_uuid} = payment) do
    status = if String.starts_with?(order_uuid, "a"), do: :rejected, else: :accepted
    %{payment | status: status}
  end

  def log_payment(%Payment{order_uuid: order_uuid}) do
    Logger.info("🏦 Bank  - ⬅️  Validating payment for order #{order_uuid}")
  end

  def log_payment_status(%Payment{status: :accepted, order_uuid: order_uuid}) do
    Logger.info("🏦 Bank  - ✅ Payment accepted for order #{order_uuid}")
  end

  def log_payment_status(%Payment{order_uuid: order_uuid}) do
    Logger.info("🏦 Bank  - ❌ Validate payment for order #{order_uuid}")
  end

  def add_payment(%Payment{status: :accepted} = payment, ledger) do
    {:ok, ledger} = Ledger.add_payment(ledger, payment)
    {{:ok, payment.uuid}, ledger}
  end

  def add_payment(%Payment{status: status}, ledger) do
    {{:error, status}, ledger}
  end
end
