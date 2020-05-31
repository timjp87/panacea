defmodule Beacon.Network.DiscV5 do
  @moduledoc """
  Implementation of Discovery V5 Peer Discovery Protocol.
  """

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    Logger.info("Starting DiscoveryV5 Service!")
    {:ok, args}
  end
end
