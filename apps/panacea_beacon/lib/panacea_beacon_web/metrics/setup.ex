defmodule BeaconWeb.Metrics.Setup do
  @moduledoc """
  Common area to set up metrics
  """

  require Logger

  def setup do
    Logger.info("Starting Prometheus Metrics on http://localhost:4000/metrics")
    BeaconWeb.Metrics.BeaconInstrumenter.setup()
    BeaconWeb.Metrics.NetworkInstrumenter.setup()

    BeaconWeb.PrometheusExporter.setup()
  end
end
