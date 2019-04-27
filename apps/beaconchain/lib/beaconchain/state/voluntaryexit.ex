defmodule Beaconchain.State.VoluntaryExit do
  @moduledoc """
  Encodes a voluntary exit of a validator in the beacon chain.
  """
  use TypedStruct

  typedstruct do
    field(:epoch, non_neg_integer(), enforce: true)
    field(:validator_index, non_neg_integer(), enforce: true)
    field(:signature, <<_::768>>, enforce: true)
  end
end
