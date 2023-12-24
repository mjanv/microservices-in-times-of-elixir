defmodule Payments.Payment do
  @moduledoc false

  @type t :: %__MODULE__{
          uuid: String.t(),
          order_uuid: String.t(),
          amount: integer(),
          status: atom()
        }

  defstruct [:uuid, :order_uuid, :amount, :status]

  def new(order_uuid: order_uuid, amount: amount) do
    %__MODULE__{uuid: UUID.uuid4(), order_uuid: order_uuid, amount: amount, status: :pending}
  end
end
