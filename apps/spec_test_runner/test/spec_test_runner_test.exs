defmodule SpecTestRunnerTest do
  use ExUnit.Case

  File.cd("../../eth2.0-spec-tests/general/phase0/ssz-generic")
  @test_vector_path
  File.ls(@test_vector_path)
    |> Enum.each(&IO.puts/1)

  test "greets the world" do
    assert true
  end
end
