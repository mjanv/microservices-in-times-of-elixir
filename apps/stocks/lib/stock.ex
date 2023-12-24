defmodule Stocks.Stock do
  @moduledoc false

  @type t :: %__MODULE__{
          items: integer()
        }

  defstruct [:items]

  def add_items(%__MODULE__{} = stock, items: items) do
    {:ok, %{stock | items: stock.items + items}}
  end

  def remove_items(stock, items \\ 1)

  def remove_items(%__MODULE__{items: items_left}, items) when items_left - items < 0 do
    {:error, :no_items_left}
  end

  def remove_items(%__MODULE__{items: items_left} = stock, items) do
    {:ok, %{stock | items: items_left - items}}
  end
end
