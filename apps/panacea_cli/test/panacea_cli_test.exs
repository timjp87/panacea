defmodule PanaceaCLITest do
  use ExUnit.Case
  doctest PanaceaCLI

  test "greets the world" do
    assert PanaceaCLI.hello() == :world
  end
end
