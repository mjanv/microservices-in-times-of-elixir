defmodule Orders.Frontend.Router do
  @moduledoc false

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "🏪 Orders")
  end

  get "/orders/new" do
    conn
    |> put_resp_content_type("text/plain")
    |> then(fn conn ->
      [items: 1, price: 1_000]
      |> Orders.Order.new()
      |> Orders.Shop.send_order()
      |> case do
        {:ok, order} ->
          send_resp(conn, 200, "✅ Order #{order.uuid} accepted")

        {:error, error} ->
          send_resp(conn, 500, "❌ Order due to #{error}")
      end
    end)
  end

  get "/orders/:order_uuid" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "📦 Order #{order_uuid} is being processed")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
