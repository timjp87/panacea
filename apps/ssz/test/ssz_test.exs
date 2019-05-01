defmodule SszTest do
  use ExUnit.Case
  doctest Ssz

  test "greets the world" do
    assert Ssz.hello() == :world
  end
end
