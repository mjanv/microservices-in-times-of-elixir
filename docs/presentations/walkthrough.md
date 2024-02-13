# Walkthrough

## Connect two nodes

```bash
iex --sname a
iex --sname b
```

```elixir
# on node b
Node.self()
Node.list()
Node.connect(:a@xps)
Node.list()

# on node a
Node.self()
Node.list()
```

```elixir
# on node a
Hello.name("Human Talks")
```

```elixir
# on node a
Node.spawn(:b@xps, fn -> Hello.name("Human Talks") end)
```

```elixir
# on node b
defmodule Hello do
  def name(name), do: IO.puts("Hello, #{name} !")
end
```

```elixir
# on node a
Node.spawn(:b@xps, fn -> Hello.name("Human Talks") end)
```

```elixir
# on node a
pid = Node.spawn :b@xps, fn ->
  receive do
    {:ping, a} -> send(a, :pong)
  end
end

send pid, {:ping, self()}
flush()
```

## Monolith application

```bash
just build monolith
just deploy monolith a
```

## Service-based application

```bash
just build frontend
just build backend
just deploy frontend a
just deploy backend b
```

## Distributed application

```bash
just build distributed
just deploy distributed a
just deploy distributed b
```