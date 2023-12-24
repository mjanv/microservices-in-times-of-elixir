defmodule Stocks.StockTest do
  @moduledoc false

  use ExUnit.Case

  alias Stocks.Stock

  test "An item can be removed from the stock if items are left" do
    stock = %Stock{items: 5}

    {:ok, stock} = Stock.remove_item(stock)

    assert stock.items == 4
  end

  test "An item can't be removed from the stock if no items are left" do
    stock = %Stock{items: 0}

    {:error, :no_items_left} = Stock.remove_item(stock)
  end

  test "A stock can be refurbished by adding items" do
    stock = %Stock{items: 3}

    {:ok, stock} = Stock.add_items(stock, items: 4)

    assert stock.items == 7
  end
end
