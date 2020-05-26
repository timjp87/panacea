defmodule Beacon.Db do
  @moduledoc """
  A server that runs our database and can be interacted with via GenServer calls.
  """
  use GenServer

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack)
  end

  def init(stack) do
    {:ok, stack}
  end

  def handle_call(request, from, state) do
  end
end
