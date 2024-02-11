defmodule Orders.Frontend.Router do
  @moduledoc false

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, """
    <h1>🏪 Orders</h1>
    <br \>
    <a href=\"/orders/new\">New order</a>
    """)
  end

  get "/orders/new" do
    conn
    |> put_resp_content_type("text/html")
    |> then(fn conn ->
      [items: 1, price: 1_000]
      |> Orders.Order.new()
      |> Orders.Shop.send_order()
      |> case do
        {:accepted, order} ->
          send_resp(conn, 200, "<h1>✅ Order #{order.uuid} accepted</h1>")

        {:refused, order} ->
          send_resp(conn, 200, "<h1>❌ Order #{order.uuid} refused</h1>")

        {:unavailable, _} ->
          send_resp(conn, 503, "<h1>🛑 Service unavailable</h1>")
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
