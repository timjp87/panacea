defmodule BeaconchainTest do
  use ExUnit.Case
  doctest Beaconchain

  test "greets the world" do
    assert Beaconchain.hello() == :world
  end
end
