defmodule Beacon.Eth1 do
  @moduledoc """
  Handels Ethereum 1 data
  """
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(arg) do
    Logger.info("Starting ETH1 Service!")
    {:ok, arg}
  end

  def get_block() do
    block = Ethereumex.HttpClient.eth_get_block_by_number("latest", true)
    IO.puts(block)
  end
end
