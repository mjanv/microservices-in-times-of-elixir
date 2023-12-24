defmodule Payments.Bank.LedgerTest do
  @moduledoc false

  use ExUnit.Case

  alias Payments.Bank.Ledger
  alias Payments.Payment

  test "A new payment can be added to the ledger" do
    ledger = %Ledger{balance: 0, payments: []}
    payment = %Payment{uuid: "123", order_uuid: "abc", amount: 100, status: :pending}

    {:ok, ledger} = Ledger.add_payment(ledger, payment)

    assert ledger.balance == 100
    assert ledger.payments == [payment]
  end

  test "A new payment can be added to a ledger with existing payments" do
    ledger = %Ledger{
      balance: 100,
      payments: [
        %Payment{uuid: "123", order_uuid: "abc", amount: 100}
      ]
    }

    payment = %Payment{uuid: "456", order_uuid: "def", amount: 200}

    {:ok, ledger} = Ledger.add_payment(ledger, payment)

    assert ledger.balance == 300

    assert ledger.payments == [
             %Payment{uuid: "123", order_uuid: "abc", amount: 100},
             %Payment{uuid: "456", order_uuid: "def", amount: 200}
           ]
  end
end
