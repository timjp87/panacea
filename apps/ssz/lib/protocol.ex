defprotocol Ssz do
  @doc """
  Merkelizes a data structure.
  """
  def serialize(value)
  def deserialize(value)
end

defimpl Ssz, for: Integer do
  def serialize(int) do
    cond do
      0 <= int and int <= :math.pow(2, 8) - 1 -> <<int::little-8>>
      :math.pow(2, 8) - 1 < int and int <= :math.pow(2, 16) - 1 -> <<int::little-16>>
      :math.pow(2, 16) - 1 < int and int <= :math.pow(2, 32) - 1 -> <<int::little-32>>
      :math.pow(2, 32) - 1 < int and int <= :math.pow(2, 64) - 1 -> <<int::little-64>>
      :math.pow(2, 64) - 1 < int and int <= :math.pow(2, 128) - 1 -> <<int::little-128>>
      :math.pow(2, 128) - 1 < int and int <= :math.pow(2, 256) - 1 -> <<int::little-256>>
    end
  end
end

defimpl Ssz, for: Atom do
  def serialize(atom) do
    case atom do
      true -> <<1>>
      false -> <<0>>
      _ -> Atom.to_charlist(atom) |> Ssz.serialize()
    end
  end
end

defimpl Ssz, for: List do
  def serialize(list) do
    List.foldr(list, <<>>, fn x, acc -> Ssz.serialize(x) <> acc end)
  end
end

defimpl Ssz, for: BitString do
  def serialize(binary) do
    binary
    |> :binary.bin_to_list()
    |> Ssz.serialize()
  end
end
