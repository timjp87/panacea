defmodule Beacon.Application do
  @moduledoc """
  Documentation for Beacon.
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:sync}, _from, state) do
    {:reply, state, state + 1}
  end

  def ping do
    IO.puts(2)
  end
end
