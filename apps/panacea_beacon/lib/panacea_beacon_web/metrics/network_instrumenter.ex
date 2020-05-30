defmodule BeaconWeb.Metrics.NetworkInstrumenter do
  @moduledoc """
  Network metrics
  """

  use Prometheus.Metric

  require Logger

  def setup do
    Gauge.declare(
      name: :libp2p_peers,
      help: "Number of currently connected peers."
    )
  end

  def newPeer() do
    Gauge.inc(name: :libp2p_peers)
  end
end
