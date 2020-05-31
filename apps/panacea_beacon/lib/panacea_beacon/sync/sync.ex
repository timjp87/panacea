defmodule Beacon.Sync do
  @moduledoc """
  Synchronizes Beaconchain and runs state transitions.
  """

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: {:global, "sync"})
  end

  def init(args) do
    Logger.info("Starting Sync Service!")
    {:ok, args}
  end
end
