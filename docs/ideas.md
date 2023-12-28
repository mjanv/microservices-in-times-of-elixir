# Ideas

- [Umbrella applications](#umbrella-applications)
- [Distributed applications](#distributed-applications)
- [Blue-green deployments](#bluegreen-deployments)

# Umbrella applications

# Distributed applications

- https://hexdocs.pm/elixir/1.16/Application.html
- https://www.erlang.org/doc/design_principles/distributed_applications
- https://hexdocs.pm/mix/Mix.Tasks.Compile.App.html
- https://learnyousomeerlang.com/distributed-otp-applications


The [kernel application](https://www.erlang.org/doc/man/kernel_app.html) can be configured in a Elixir application through two ways. Firstly, the `vm.args` file can be edited to add key/values through the syntax:

```erlang
-kernel config_key config_value
```

The other way is to configure them dynamically through the `config/runtime.exs` file, before making the application reboot after the configuration phase using the syntax:

```elixir
# config/runtime.exs
if config_env() == :prod do
  config :kernel,
    config_key: config_value
end

# mix.exs
releases: [
  my_app: [reboot_system_after_config: true]
]
```

# Blue/Green deployments

- https://blog.differentpla.net/blog/2023/03/21/remote-load-erlang-modules/