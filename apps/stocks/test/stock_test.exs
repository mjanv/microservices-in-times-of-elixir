defmodule Stocks.StockTest do
  @moduledoc false

  use ExUnit.Case

  alias Stocks.Stock

  test "Items can be removed from the stock if items are left" do
    stock = %Stock{items: 5}

    {:ok, stock} = Stock.remove_items(stock, 2)

    assert stock.items == 3
  end

  test "Items cant be removed from the stock if no items are left" do
    stock = %Stock{items: 0}

    {:error, stock} = Stock.remove_items(stock)

    assert stock.items == 0
  end

  test "Items can't be removed from the stock if not enough items are left" do
    stock = %Stock{items: 3}

    {:error, stock} = Stock.remove_items(stock, 4)

    assert stock.items == 3
  end

  test "A stock can be refurbished by adding items" do
    stock = %Stock{items: 3}

    {:ok, stock} = Stock.add_items(stock, items: 4)

    assert stock.items == 7
  end

  test "A stock can be refurbished when the number of items is under a certain threshold" do
    stock = %Stock{items: 3}

    {:ok, stock} = Stock.restock(stock, threshold: 5, new_items: 10)

    assert stock.items == 13
  end

  test "A stock can be not refurbished when the number of items is over a certain threshold" do
    stock = %Stock{items: 7}

    {:error, stock} = Stock.restock(stock, threshold: 5, new_items: 10)

    assert stock.items == 7
  end
end
