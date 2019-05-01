defmodule Ssz.Util do
  @moduledoc """
  Helper function for simple serialize implementation.
  """

  @bytes_per_chunk 32
  def pack(chunks) do
    chunks
    |> :binary.bin_to_list()
    |> Enum.chunk_every(32, 32, [0])
  end

  def mix_in_length(value, length) do
  end

  def merkelize(chunks) do
  end
end
