defmodule Beacon.Eth1 do
  @moduledoc """
  Handels Ethereum 1 data
  """
  import Ethereumex

  use GenServer

  def init() do
    {:ok, "Hallo"}
  end

  def getBlock() do
    block = Ethereumex.HttpClient.eth_get_block_by_number("latest", true)
    IO.puts(block)
  end
end
