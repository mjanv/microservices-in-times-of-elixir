defmodule Orders.Order do
  @moduledoc false

  @type t :: %__MODULE__{
          uuid: String.t(),
          items: integer(),
          price: integer()
        }

  defstruct [:uuid, :items, :price]

  def new(items: items, price: price) do
    %__MODULE__{uuid: UUID.uuid4(), items: items, price: price}
  end
end
