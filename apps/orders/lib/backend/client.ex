defmodule Orders.Backend.Client do
  @moduledoc """
  A client is a fake process imitating order requests from the frontend.

  By default, a new order is sent every second. To be enabled, the client must be added to the supervision tree.
  """

  use GenServer

  alias Orders.{Order, Shop}

  @interval 1_000

  @doc "Start the client"
  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Process.send_after(self(), :new, @interval)
    {:ok, args}
  end

  @impl true
  def handle_info(:new, state) do
    Process.send_after(self(), :new, @interval)
    {:ok, _} = [items: 1, price: 1_000] |> Order.new() |> Shop.send_order()
    {:noreply, state}
  end
end
