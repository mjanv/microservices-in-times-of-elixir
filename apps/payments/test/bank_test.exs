defmodule Payments.BankTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Payments.Bank
  alias Payments.Bank.Ledger
  alias Payments.Payment

  test "A payment can be rejected" do
    payment = %Payments.Payment{order_uuid: "a-uuid"}
    payment = Bank.payment_accepted?(payment)

    assert payment.status == :rejected
  end

  test "A payment can be accepted" do
    payment = %Payment{order_uuid: "b-uuid"}

    payment = Bank.payment_accepted?(payment)

    assert payment.status == :accepted
  end

  test "Accepted payments are inserted in the ledger" do
    ledger = Ledger.new()
    payment = %Payment{status: :accepted, amount: 4}

    {{:ok, _}, ledger} = Bank.add_payment(payment, ledger)

    assert ledger.balance == 4
    assert ledger.payments == [payment]
  end

  test "Rejected payments are not inserted in the ledger" do
    ledger = Ledger.new()
    payment = %Payment{status: :rejected}

    {{:error, :rejected}, ledger} = Bank.add_payment(payment, ledger)

    assert ledger.payments == []
  end
end
