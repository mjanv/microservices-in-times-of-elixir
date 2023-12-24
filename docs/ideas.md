# Distributed applications

- https://hexdocs.pm/elixir/1.16/Application.html
- https://www.erlang.org/doc/design_principles/distributed_applications
- https://hexdocs.pm/mix/Mix.Tasks.Compile.App.html
- https://learnyousomeerlang.com/distributed-otp-applications

```
If you want to configure these applications for a release, you can
specify them in your vm.args file:

    -kernel config_key config_value

Alternatively, if you must configure them dynamically, you can wrap
them in a conditional block in your config files:

    if System.get_env("RELEASE_MODE") do
      config :kernel, ...
    end

and then configure your releases to reboot after configuration:

    releases: [
      my_app: [reboot_system_after_config: true]
    ]
```

# Blue/Green deployments

- https://blog.differentpla.net/blog/2023/03/21/remote-load-erlang-modules/