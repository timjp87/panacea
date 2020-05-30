defmodule Beacon.Util.Misc do
  @moduledoc """
  Miscellaneous helper functions for other modules.
  """
  alias Beacon.Chain.Params

  @doc """
  Return the shuffled index corresponding to ``seed`` (and ``index_count``).
  """
  def compute_shuffled_index(index, index_count, seed) do
    if index < index_count do
      Enum.each(1..Params.decode(:shuffle_round_count), fn x -> IO.puts(x) end)
    end
  end
end
