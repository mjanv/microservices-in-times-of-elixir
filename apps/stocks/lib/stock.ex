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

  def remove_items(%__MODULE__{items: items_left} = stock, items) when items_left - items < 0 do
    {:error, stock}
  end

  def remove_items(%__MODULE__{items: items_left} = stock, items) do
    {:ok, %{stock | items: items_left - items}}
  end

  def restock(%__MODULE__{items: stocks} = stock, threshold: threshold, new_items: new_items) do
    if stocks < threshold do
      add_items(stock, items: new_items)
    else
      {:error, stock}
    end
  end
end
