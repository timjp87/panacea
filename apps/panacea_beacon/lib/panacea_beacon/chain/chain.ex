defmodule Beacon.Chain do
  @moduledoc """
  This module allows the network to reach consensus on the state of the protocol itself.
  It is responsible for handling the life cycle of blocks, and applies the fork choice rule
  and state transition function provided by the core package to advance the beacon chain.
  """

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    Logger.info("Starting Beaconchain Service!")
    {:ok, args}
  end
end
