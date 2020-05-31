defmodule Beacon.Network.P2P do
  @moduledoc """
  Handles networking stuff.
  """

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(opts) do
    Logger.info("Initlizing LibP2P Service!")
    {_, pid} = :libp2p_swarm.start(:panacea_beacon, opts)
    :libp2p_swarm.listen(pid, 9000)
    {:ok, pid}
  end
end
