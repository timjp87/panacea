defmodule Beaconchain.Eth1Listener do
  @moduledoc """
  Listens for log events on the validator registry contract on the Ethereum 1.0 chain.
  This will kick of the chainstart once the Genesis2 log has been emmited. Deposit logs
  will be listed to for tracking of new validators.
  """
  use GenServer

  def init(init_arg) do
    ExW3.Contract.start_link()
    listen_for_event()
    {:ok, init_arg}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def listen_for_event do
    :timer.sleep(1000)
    # Recurse
    listen_for_event()
  end
end
