defmodule Orders.Frontend.Plug do
  @moduledoc false

  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> then(fn conn ->
      {:ok, order_uuid} = Orders.Shop.new_order()
      send_resp(conn, 200, "✅ Order #{order_uuid} accepted")
    end)
  end
end
