defmodule Orders.Order do
  @moduledoc """
  An order is a request to buy an amount of items for a given price.
  """

  @type t :: %__MODULE__{
          uuid: String.t(),
          items: integer(),
          price: integer()
        }

  defstruct [:uuid, :items, :price]

  @doc "Creates a new order."
  @spec new([{:items, integer()}, {:price, integer()}]) :: t()
  def new(items: items, price: price) do
    %__MODULE__{uuid: UUID.uuid4(), items: items, price: price}
  end
end
