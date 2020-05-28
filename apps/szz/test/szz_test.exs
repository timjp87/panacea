defmodule SzzTest do
  use ExUnit.Case
  doctest Szz

  test "greets the world" do
    assert Szz.hello() == :world
  end
end
