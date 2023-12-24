defmodule Orders.Backend.Client do
  @moduledoc false

  use GenServer

  alias Orders.{Order, Shop}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    Process.send_after(self(), :new, 1_000)
    {:ok, args}
  end

  def handle_info(:new, state) do
    Process.send_after(self(), :new, 1_000)
    {:ok, _} = [items: 1, price: 1_000] |> Order.new() |> Shop.send_order()
    {:noreply, state}
  end
end
