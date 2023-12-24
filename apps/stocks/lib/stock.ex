defmodule Stocks.Stock do
  @moduledoc false

  require Logger

  @type t :: %__MODULE__{
          items: integer()
        }

  defstruct [:items]

  def is_stock_available?(order_uuid, node) do
    {Stocks.TaskSupervisor, node}
    |> Task.Supervisor.async(__MODULE__, :do_is_stock_available, [order_uuid])
    |> Task.await()
  end

  def do_is_stock_available(order_uuid) do
    %__MODULE__{items: 5}
    |> remove_item()
    |> tap(fn
      {:ok, _} ->
        Logger.info("📦 Stock - ⬅️  Check stock for order #{order_uuid}")
        Logger.info("📦 Stock - ✅ Order #{order_uuid} accepted")

      {:error, _} ->
        Logger.info("📦 Stock - ⬅️  Check stock for order #{order_uuid}")
        Logger.info("📦 Stock - ❌ Order #{order_uuid} rejected")
    end)
  end

  def remove_item(%__MODULE__{items: items}) when items <= 0 do
    {:error, :no_items_left}
  end

  def remove_item(%__MODULE__{items: items} = stock) do
    {:ok, %{stock | items: items - 1}}
  end
end
