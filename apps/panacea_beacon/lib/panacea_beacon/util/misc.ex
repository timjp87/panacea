defmodule Beacon.Util.Misc do
  @moduledoc """
  Miscellaneous helper functions for other modules.
  """
  alias Beacon.Chain.Params
  alias Beacon.Util.Math

  @doc """
  Return the shuffled index corresponding to ``seed`` (and ``index_count``).
  """
  def compute_shuffled_index(index, index_count, seed) do
    if index < index_count do
      Enum.each(1..Params.decode(:shuffle_round_count), &compute_shuffled_index(&1, index, index_count, seed))
    end
  end

        @doc """
        pivot = bytes_to_int(hash(seed + int_to_bytes(current_round, length=1))[0:8]) % index_count
        flip = (pivot + index_count - index) % index_count
        position = max(index, flip)
        source = hash(seed + int_to_bytes(current_round, length=1) + int_to_bytes(position // 256, length=4))
        byte = source[(position % 256) // 8]
        bit = (byte >> (position % 8)) % 2
        index = flip if bit else index
        """
  defp compute_shuffled_index(current_round, index, index_count, seed) do
        seed + Math.int_to_bytes(current_round, 1)
            |> Math.hash
            |> IO.puts
  end
end
