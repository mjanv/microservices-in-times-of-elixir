defmodule Microservices.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def releases do
    [
      monolith: [
        applications: [orders: :permanent, payments: :permanent, stocks: :permanent],
        runtime_config_path: "config/runtime_monolith.exs"
      ],
      frontend: [
        applications: [orders: :permanent],
        runtime_config_path: "config/runtime_service_based.exs"
      ],
      backend: [
        applications: [payments: :permanent, stocks: :permanent],
        runtime_config_path: "config/runtime_service_based.exs"
      ],
      distributed: [
        applications: [orders: :permanent, payments: :permanent, stocks: :permanent],
        runtime_config_path: "config/runtime_distributed.exs",
        reboot_system_after_config: true
      ]
    ]
  end

  defp aliases do
    [
      quality: ["format", "credo --strict", "dialyzer"],
      test: ["test --trace"],
      docs: ["doctor", "cmd mix docs"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: :dev}
    ]
  end
end
