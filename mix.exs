defmodule Panacea.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:distillery, "~> 2.0"},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
