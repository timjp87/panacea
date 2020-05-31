defmodule Beacon.Util.Crypto do
  @moduledoc """
  Crypto helper functions for other modules.
  """

  @doc """
  Returns SHA256 hash of given data.
  """
  def hash(data) do
    :crypto.hash(:sha256, data)
  end
end
