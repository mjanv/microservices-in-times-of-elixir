defmodule Payments.Bank.Ledger do
  @moduledoc false

  alias Payments.Payment

  @type t :: %__MODULE__{
          balance: integer(),
          payments: [Payments.Payment.t()]
        }

  defstruct [:balance, :payments]

  def new do
    %__MODULE__{balance: 0, payments: []}
  end

  def add_payment(%__MODULE__{} = ledger, %Payment{} = payment) do
    ledger = %{
      ledger
      | balance: ledger.balance + payment.amount,
        payments: ledger.payments ++ [payment]
    }

    {:ok, ledger}
  end
end
