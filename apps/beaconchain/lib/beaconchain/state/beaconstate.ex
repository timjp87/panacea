defmodule Beaconchain.State.BeaconchainState do
  @moduledoc """
  This module implements the state of the beacon chain.
  """
  use TypedStruct

  alias Beaconchain.State.{
    Fork,
    Eth1Data,
    Block,
    Attestation.PendingAttestation,
    Validator,
    Crosslink
  }

  typedstruct do
    # Misc
    field(:slot, non_neg_integer(), enforce: true)
    field(:genesis_time, non_neg_integer(), enforce: true)
    field(:fork, Fork.t(), enforce: true)

    # Validator registry
    field(:validator_registry, Validator.t(), enforce: true)
    field(:balances, [non_neg_integer()], enforce: true)

    # Randomness and committee
    field(:latest_randao_mixes, [<<_::256>>], enforce: true)
    field(:latest_start_shard, non_neg_integer(), enforce: true)

    # Finality
    field(:previous_epoch_attestations, [PendingAttestation.t()], enforce: true)
    field(:current_epoch_attestations, [PendingAttestation.t()], enforce: true)
    field(:previous_justified_epoch, non_neg_integer(), enforce: true)
    field(:current_justified_epoch, non_neg_integer(), enforce: true)
    field(:previous_justified_root, <<_::256>>, enforce: true)
    field(:current_justified_root, <<_::256>>, enforce: true)
    field(:justification_bitfield, non_neg_integer(), enforce: true)
    field(:finalized_epoch, non_neg_integer(), enforce: true)
    field(:finalized_root, <<_::256>>, enforce: true)

    #  Recent state
    field(:current_crosslinks, [Crosslink.t()], enforce: true)
    field(:previous_crosslinks, [Crosslink.t()], enforce: true)
    field(:latest_block_roots, [<<_::256>>], enforce: true)
    field(:latest_state_roots, [<<_::256>>], enforce: true)
    field(:latest_active_index_roots, [<<_::256>>], enforce: true)
    field(:latest_slashed_balances, [non_neg_integer()], enforce: true)
    field(:latest_block_header, Block.Header.t(), enforce: true)
    field(:historical_roots, [<<_::256>>], enforce: true)

    # Ethereum 1.0 chain data
    field(:latest_eth1_data, Eth1Data.t(), enforce: true)
    field(:eth1_data_votes, [Eth1Data.t()], enforce: true)
    field(:deposit_index, non_neg_integer(), enforce: true)
  end
end
