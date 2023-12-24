defmodule Microservices.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      aliases: aliases()
    ]
  end

  def releases do
    [
      monolith: [
        reboot_system_after_config: true,
        applications: [orders: :permanent, payments: :permanent, stocks: :permanent]
      ],
      frontend: [
        reboot_system_after_config: true,
        applications: [orders: :permanent],
        cookie: "secret"
      ],
      backend: [
        reboot_system_after_config: true,
        applications: [payments: :permanent, stocks: :permanent],
        cookie: "secret"
      ]
    ]
  end

  defp aliases do
    [
      quality: ["format", "credo --strict"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
