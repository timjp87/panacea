defmodule Beacon.State.Eth1Data do
  use TypedStruct

  typedstruct do
    field(:deposti_root, <<_::256>>, enforce: true)
    field(:deposit_count, non_neg_integer(), enforce: true)
    field(:block_root, <<_::256>>, enforce: true)
  end
end
