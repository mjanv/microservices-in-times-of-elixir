defmodule Stocks.Stock do
  @moduledoc false

  @type t :: %__MODULE__{
          items: integer()
        }

  defstruct [:items]

  def add_items(%__MODULE__{} = stock, items: items) do
    {:ok, %{stock | items: stock.items + items}}
  end

  def remove_item(%__MODULE__{items: items}) when items <= 0 do
    {:error, :no_items_left}
  end

  def remove_item(%__MODULE__{items: items} = stock) do
    {:ok, %{stock | items: items - 1}}
  end
end
