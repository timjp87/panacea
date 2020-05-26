defmodule Beacon.State.Validator do
  @moduledoc """
  This module encodes the validator data structure.
  """
  use TypedStruct

  typedstruct do
    field(:pubkey, <<_::384>>, enforce: true)
    field(:withdrawal_credentials, <<_::256>>, enforce: true)
    field(:activation_eligibility_epoch, non_neg_integer(), enforce: true)
    field(:activation_epoch, non_neg_integer(), enforce: true)
    field(:exit_epoch, non_neg_integer(), enforce: true)
    field(:withdrawable_epoch, non_neg_integer(), enforce: true)
    field(:slashed, boolean(), enforce: true)
    field(:high_balance, non_neg_integer(), enforce: true)
  end
end
