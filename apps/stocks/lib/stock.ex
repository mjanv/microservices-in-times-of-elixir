defmodule Stocks.Stock do
  @moduledoc """
  A stock is represented as a number of items.

  Available operations are to add or remove items from the stock. Stock can also be restocked to add items when the stock is low.
  """

  @type t :: %__MODULE__{
          items: integer()
        }

  defstruct [:items]

  @doc "Add items to the stock."
  @spec add_items(t(), items: integer()) :: {:ok, t()}
  def add_items(%__MODULE__{} = stock, items: items) do
    {:ok, %{stock | items: stock.items + items}}
  end

  @doc "Remove items from the stock."
  @spec remove_items(t(), items: integer()) :: {:ok, t()} | {:error, t()}
  def remove_items(%__MODULE__{items: items_left} = stock, items: items) do
    if items_left - items < 0 do
      {:error, stock}
    else
      {:ok, %{stock | items: items_left - items}}
    end
  end

  @doc "Restock the stock if the number of items is below a threshold."
  @spec restock(t(), threshold: integer(), new_items: integer()) :: {:ok, t()} | {:error, t()}
  def restock(%__MODULE__{items: stocks} = stock, threshold: threshold, new_items: new_items) do
    if stocks < threshold do
      add_items(stock, items: new_items)
    else
      {:error, stock}
    end
  end
end
