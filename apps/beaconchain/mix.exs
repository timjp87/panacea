defmodule Beaconchain.MixProject do
  use Mix.Project

  def project do
    [
      app: :beaconchain,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:ethereumex, :libp2p],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exw3, "~> 0.4.4"},
      {:libp2p, "~> 0.1.0"},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
