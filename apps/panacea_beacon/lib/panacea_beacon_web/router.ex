defmodule BeaconWeb.Router do
  use BeaconWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BeaconWeb do
    pipe_through :api
  end
end
