defmodule Beaconchain.State.Crosslink do
  @moduledoc """
  Encodes crosslinks from shards in the beacon chain.
  """
  use TypedStruct

  typedstruct do
    field(:epoch, non_neg_integer(), enforce: true)
    field(:previous_crosslink_root, <<_::256>>, enforce: true)
    field(:crosslink_data_root, <<_::256>>, enforce: true)
  end
end
