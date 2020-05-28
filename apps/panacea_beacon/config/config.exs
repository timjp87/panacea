# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :panacea_beacon,
  namespace: Beacon

# Configures Ethereum RPC Interface
config :ethereumex,
  url: "http://localhost:8545"

# Configures the endpoint
config :panacea_beacon, BeaconWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sfRGUhY1AVZQlzak+fv3HARYTOeI9MAnNnU2N/T542kr5742mfSA3vhm2BIxRQnE",
  render_errors: [view: BeaconWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Beacon.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$date $time $metadata[$level] $message Test\n",
  colors: [enabled: true],
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
