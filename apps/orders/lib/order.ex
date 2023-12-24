defmodule Orders.Order do
  @moduledoc false

  @type t :: %__MODULE__{
          uuid: String.t(),
          amount: integer()
        }

  defstruct [:uuid, :amount]

  def new(amount: amount) do
    %__MODULE__{uuid: UUID.uuid4(), amount: amount}
  end
end
