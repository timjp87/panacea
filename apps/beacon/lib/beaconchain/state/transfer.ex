defmodule Beacon.State.Transfer do
  @moduledoc """
  A Transfer in the Beacon Chain.
  """
  use TypedStruct

  typedstruct do
    field(:sender, non_neg_integer(), enforce: true)
    field(:receipt, non_neg_integer(), enforce: true)
    field(:amount, non_neg_integer(), enforce: true)
    field(:fee, non_neg_integer(), enforce: true)
    field(:slot, non_neg_integer(), enforce: true)
    field(:pubkey, <<_::348>>, enforce: true)
    field(:signature, <<_::769>>, enforce: true)
  end
end
