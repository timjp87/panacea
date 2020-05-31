defmodule Beacon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the API endpoint when the application starts
      BeaconWeb.Endpoint,
      # Start the rest of the beacon node services.
      {Beacon.DB, []},
      {Beacon.Chain, []},
      # {Beacon.Network.P2P, []},
      {Beacon.Network.DiscV5, []},
      {Beacon.Sync, []},
      {Beacon.Eth1, []}
    ]

    BeaconWeb.Metrics.Setup.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beacon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BeaconWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
