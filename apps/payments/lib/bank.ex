defmodule Payments.Bank do
  @moduledoc false

  use GenServer

  require Logger

  alias Payments.Bank.Ledger
  alias Payments.Payment

  @doc "Start the bank"
  @spec start_link(any()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__})
  end

  @impl true
  def init(_args) do
    Process.flag(:trap_exit, true)
    Logger.info("└ 💵 Payments - 🏦 Bank - Start service")
    {:ok, Ledger.new()}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("  💵 Payments - 🏦 Bank - Stop service due to #{inspect(reason)}")
    :ok
  end

  @impl true
  def handle_call({:pay, order_uuid, amount}, _from, ledger) do
    Payment.new(order_uuid: order_uuid, amount: amount)
    |> pay(ledger)
    |> then(fn {response, ledger} -> {:reply, response, ledger} end)
  end

  @doc "Pay an order"
  @spec pay(Payment.t(), Ledger.t()) :: {{:error, Ledger.t()} | {:ok, binary()}, Ledger.t()}
  def pay(%Payment{} = payment, %Ledger{} = ledger) do
    payment
    |> tap(&log_payment/1)
    |> then(&payment_accepted?/1)
    |> tap(&log_payment_status/1)
    |> then(&add_payment(&1, ledger))
  end

  @doc "Check if the payment is accepted"
  @spec payment_accepted?(Payment.t()) :: Payment.t()
  def payment_accepted?(%Payment{order_uuid: order_uuid} = payment) do
    status = if String.starts_with?(order_uuid, "a"), do: :rejected, else: :accepted
    %{payment | status: status}
  end

  @spec log_payment(Payment.t()) :: :ok
  defp log_payment(%Payment{order_uuid: order_uuid}) do
    Logger.info("🏦 Bank \t| ⬅️  Validating payment for order #{order_uuid}")
  end

  @spec log_payment_status(Payment.t()) :: :ok
  defp log_payment_status(%Payment{status: :accepted, order_uuid: order_uuid}) do
    Logger.info("🏦 Bank \t| ✅ Payment accepted for order #{order_uuid}")
  end

  defp log_payment_status(%Payment{order_uuid: order_uuid}) do
    Logger.info("🏦 Bank \t| ❌ Validate payment for order #{order_uuid}")
  end

  @doc "Add a payment to the ledger"
  @spec add_payment(Payment.t(), Ledger.t()) ::
          {{:error, Ledger.t()} | {:ok, binary()}, Ledger.t()}
  def add_payment(%Payment{status: :accepted} = payment, %Ledger{} = ledger) do
    {:ok, ledger} = Ledger.add_payment(ledger, payment)
    {{:ok, payment.uuid}, ledger}
  end

  def add_payment(%Payment{} = payment, %Ledger{} = ledger) do
    {{:error, payment.status}, ledger}
  end
end
