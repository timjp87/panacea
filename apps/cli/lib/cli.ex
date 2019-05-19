defmodule Cli do
  @moduledoc """
  Command line interface for the Ethereum 2.0 stack which can start the beacon chain and validators with arguments.
  """
  use Application

  def start(_type, _arg) do
    children = [
      {Beaconchain.Eth1Listener, []},
      {Beaconchain.Db, []}
    ]

    opts = [strategy: :one_for_one, name: Cli.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
