defmodule Payments.Payment do
  @moduledoc """
  Payments represent a payment request for an order.

  Payments can be created when the user requests a new order. It is fully defined by its UUID, the UUID of the order it is related to, the amount to pay and its status.

  Valid status are pending, accepted or rejected.
  """

  @type t :: %__MODULE__{
          uuid: String.t(),
          order_uuid: String.t(),
          amount: integer(),
          status: atom()
        }

  defstruct [:uuid, :order_uuid, :amount, :status]

  @doc "Create a new payment with a pending status"
  @spec new(order_uuid: String.t(), amount: integer()) :: t()
  def new(order_uuid: order_uuid, amount: amount) do
    %__MODULE__{
      uuid: String.slice(UUID.uuid4(), 0..7),
      order_uuid: order_uuid,
      amount: amount,
      status: :pending
    }
  end
end
