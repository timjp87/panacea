defmodule Beacon.Eth1 do
  @moduledoc """
  Handels Ethereum 1 data
  """
  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :eth1)
  end

  def init(arg) do
    Logger.info("Starting ETH1 Service!")
    {:ok, arg}
  end

  def greet(name) do
    GenServer.call(:eth1, {:greet, name})
  end

  def get_block() do
    GenServer.call(:eth1, :get_block)
  end

  def handle_call({:greet, name}, _from, state) do
    {:reply, "Hallo " <> name <> "!", state}
  end

  def handle_call(:get_block, _from, state) do
    block = Ethereumex.HttpClient.eth_get_block_by_number("latest", true)
    {:reply, block, state}
  end
end
