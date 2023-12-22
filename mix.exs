defmodule Microservices.MixProject do
  @moduledoc false

  use Mix.Project

  @version "0.1.0"

  def project do
    [
      apps_path: "apps",
      version: @version,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      aliases: aliases()
    ]
  end

  def releases do
    [
      monolith: [
        applications: [orders: :permanent, payments: :permanent, stocks: :permanent]
      ],
      frontend: [
        applications: [orders: :permanent],
        cookie: "secret"
      ],
      backend: [
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
