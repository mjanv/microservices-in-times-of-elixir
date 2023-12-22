defmodule Payments.MixProject do
  use Mix.Project

  def project do
    [
      app: :payments,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Payments.Application, []}
    ]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:libcluster, "~> 3.3"}
    ]
  end
end
