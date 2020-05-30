defmodule Beacon.P2P do
  @moduledoc """
  Handles networking stuff.
  """

  use GenServer

  def init(opts) do
    {_, pid} = :libp2p_swarm.start(:panacea_beacon, opts)
    :libp2p_swarm.listen(pid, 6969)
    {:ok, pid}
  end
end
