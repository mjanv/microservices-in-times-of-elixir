defmodule Stocks do
  @moduledoc false

  defdelegate stock_available?(order_uuid, items, node), to: Stocks.Warehouse
end
