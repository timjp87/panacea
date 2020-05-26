defmodule Mix.Tasks.Deploy do
  use Mix.Task

  @moduledoc """
  Starts local test blockchain with validator deposit contract deployed.
  CHAIN_START_FULL_DEPOSIT_THRESHOLD is set to 4 to start a Eth2Genesis log.
  MIN_DEPOSIT is 1 ETH and MAX_DEPOSIT is 32 ETH.
  """

  require Logger

  @shortdoc "Deploys the deposit contract."
  def run(_argv) do
    Logger.info("Deploying validator deposit contract.")
    {:ok, _started} = Application.ensure_all_started(:ethereumex)
    Logger.info("Started Ethereumex Application.")
    accounts = ExW3.accounts()
    Logger.info("Got list of accounts from RPC.")
    ExW3.Contract.start_link()
    Logger.info("Started contract manager.")
    abi = ExW3.load_abi("apps/beaconchain/lib/mix/tasks/DepositContract.abi")
    Logger.info("Loaded contract ABI.")
    ExW3.Contract.register(:DepositContract, abi: abi)
    Logger.info("Contract registered.")

    {:ok, address, tx_hash} =
      ExW3.Contract.deploy(:DepositContract,
        bin: ExW3.load_bin("apps/beaconchain/lib/mix/tasks/DepositContract.bin"),
        options: %{gas: 300_000, from: Enum.at(accounts, 0)}
      )

    ExW3.Contract.at(:DepositContract, address)
    Logger.info("Contract deployed at: #{address} with tx #{tx_hash}")
  end
end
