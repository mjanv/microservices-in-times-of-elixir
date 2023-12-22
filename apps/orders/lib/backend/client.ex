defmodule Orders.Backend.Client do
  @moduledoc false

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    Process.send_after(self(), :new, 5_000)
    {:ok, args}
  end

  def handle_info(:new, state) do
    Process.send_after(self(), :new, 15_000)
    {:ok, _} = Orders.Shop.new_order()
    {:noreply, state}
  end
end
