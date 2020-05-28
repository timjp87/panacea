defmodule SpecTestRunnerTest do
  use ExUnit.Case
  doctest SpecTestRunner

  test "greets the world" do
    assert SpecTestRunner.hello() == :world
  end
end
