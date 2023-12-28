defmodule Payments.Bank.Ledger do
  @moduledoc """
  A ledger represents a record of all payments made to the bank.

  It is defined by its current balance and a list of payments. The current balance is the sum of all payment amounts.
  """

  alias Payments.Payment

  @type t :: %__MODULE__{
          balance: integer(),
          payments: [Payments.Payment.t()]
        }

  defstruct [:balance, :payments]

  @doc "Create a new ledger"
  @spec new() :: t()
  def new do
    %__MODULE__{balance: 0, payments: []}
  end

  @doc "Add a payment to the ledger"
  @spec add_payment(t(), Payments.Payment.t()) :: {:ok, t()}
  def add_payment(%__MODULE__{} = ledger, %Payment{} = payment) do
    ledger = %{
      ledger
      | balance: ledger.balance + payment.amount,
        payments: ledger.payments ++ [payment]
    }

    {:ok, ledger}
  end
end
