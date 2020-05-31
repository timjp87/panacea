defmodule Beacon.Util.Math do
  @moduledoc """
  Math helper functions for other modules.
  """
  use Bitwise

  @doc """
  Return the ``length``-byte serialization of ``n`` in ``ENDIANNESS``-endian.
  """
  def int_to_bytes(n, length) do
    length = 8 * length
    << n :: little-integer-size(length)>>
  end

  @doc """
  Return the integer deserialization of ``data`` interpreted as ``ENDIANNESS``-endian.
  """
  def bytes_to_int(data) do
    :binary.decode_unsigned(data, :little)
  end

  @doc """
  Return the exclusive-or of two 32-byte strings.
  """
  def xor(bytes_a, bytes_b) do
    a = bytes_to_int(bytes_a)
    b = bytes_to_int(bytes_b)
    xor = a ^^^ b
    int_to_bytes(xor, 32)
  end
end
