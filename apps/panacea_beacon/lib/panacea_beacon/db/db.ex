defmodule Beacon.DB do
  @moduledoc """
  Beaconchain State Database implementation.
  """
  require Logger
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :db)
  end

  def init(opts) do
    Logger.info("Starting CubDB")
    CubDB.start_link(opts)
  end

  # Public API

  def put(key, value) do
    GenServer.cast(:db, {:put, {key, value}})
  end

  def get(key) do
    GenServer.call(:db, {:get, key})
  end

  # GenServer API

  def handle_call(db, {:get, key}) do
    CubDB.get(db, key)
  end
end
