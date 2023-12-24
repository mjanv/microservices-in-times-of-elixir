defmodule Stocks do
  @moduledoc false

  defdelegate stock_available?(order_uuid, node), to: Stocks.Warehouse
end
