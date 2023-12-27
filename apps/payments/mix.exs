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
      elixir: "~> 1.16",
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Payments.Application, []}
    ]
  end

  defp aliases do
    [
      docs: ["docs -f html -o ../../doc/payments"]
    ]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:libcluster, "~> 3.3"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
