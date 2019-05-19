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
      applications: [:ethereumex, :grpc],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:yamerl, "~> 0.7.0"},
      {:horde, "~> 0.4.0-rc.2"},
      {:grpc, "~> 0.3.1"},
      {:protobuf, "~> 0.6.1"},
      {:cachex, "~> 3.1"},
      {:ranch, "~> 1.6"},
      {:exw3, "~> 0.4.3"},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
