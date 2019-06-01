defmodule Beaconchain.Eth1Listener do
  @moduledoc """
  Listens for log events on the validator registry contract on the Ethereum 1.0 chain.
  This will kick of the chainstart once the Genesis2 log has been emmited. Deposit logs
  will be listed to for tracking of new validators.
  """
  use GenServer
  require Logger

  def init(init_arg) do
    Logger.info("Start listening for deposit logs...")
    ExW3.Contract.start_link()
    abi = ExW3.load_abi("apps/beaconchain/lib/mix/tasks/DepositContract.abi")
    ExW3.Contract.register(:DepositContract, abi: abi)

    ExW3.Contract.at(
      :DepositContract,
      Application.get_env(:beaconchain, :deposit_contract_address)
    )

    # {:ok, filter_id} = ExW3.Contract.filter(:DepositContract, "Deposit")
    listen_for_event()
    {:ok, init_arg}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def listen_for_event() do
    {:ok, changes} = ExW3.Contract.call(:DepositContract, :get)
    Logger.info(changes)
    :timer.sleep(1000)
    # Recurse
    listen_for_event()
  end
end
