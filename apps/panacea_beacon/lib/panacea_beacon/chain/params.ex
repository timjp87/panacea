defmodule Beacon.Chain.Params do
  @moduledoc """
  Defines global parameters for ETH 2.0 as defined in the specifiction:
  https://github.com/ethereum/eth2.0-specs/blob/dev/specs/phase0/beacon-chain.md
  """

  values = [
    # Misc
    eth1_follow_distance: :math.pow(2, 10),
    max_committes_per_slot: :math.pow(2, 6),
    target_committe_size: :math.pow(2, 7),
    max_validator_per_committe: :math.pow(2, 11),
    min_per_epoche_churn_limit: :math.pow(2, 16),
    shuffle_round_count: 90,
    min_genesis_active_validator_count: :math.pow(2, 14),
    min_genesis_time: 1_578_009_600,
    hysteresis_quotient: 4,
    hysteresis_downward_multiplier: 1,
    hysteresis_upward_multiplier: 5,

    # Gwei values
    min_deposit_amount: :math.pow(2, 0) * :math.pow(10, 9),
    max_effective_balance: :math.pow(2, 5) * :math.pow(10, 9),
    ejection_balance: :math.pow(2, 4) * :math.pow(10, 9),
    effective_balance_increment: :math.pow(2, 0) * :math.pow(10, 9),

    # Initial values
    genesis_fork_version: 0x00000000,
    bls_withdrawal_prefix: 0x00,

    # Time Parameters
    min_genesis_delay: 86_400,
    seconds_per_slot: 12,
    seconds_per_eth1_block: 14,
    min_attestation_inclusion_delay: :math.pow(2, 0),
    slots_per_epoch: :math.pow(2, 5),
    min_seed_lookahead: :math.pow(2, 0),
    max_seed_lookahead: :math.pow(2, 2),
    min_epochs_to_inactivity_paneltiy: :math.pow(2, 2),
    epochs_per_eth1_voting_period: :math.pow(2, 5),
    slots_per_historical_root: :math.pow(2, 13),
    min_validator_withdrawability_delay: :math.pow(2, 8),
    shard_committee_peroid: :math.pow(2, 8),

    # State list lengths
    epochs_per_historical_vector: :math.pow(2, 16),
    epochs_per_slashing_vector: :math.pow(2, 13),
    historical_roots_limit: :math.pow(2, 24),
    validator_registry_limit: :math.pow(2, 40),

    # Rewards and penalties
    base_reward_factor: :math.pow(2, 6),
    whistleblower_reward_quotient: :math.pow(2, 9),
    proposer_reward_quotient: :math.pow(2, 3),
    inactivity_penality_quotient: :math.pow(2, 24),
    min_slashing_penality_quotient: :math.pow(2, 5),

    # Max operations per Block
    max_proposer_slashings: :math.pow(2, 4),
    max_attester_slashings: :math.pow(2, 1),
    max_attestations: :math.pow(2, 7),
    max_depostis: :math.pow(2, 4),
    max_voluntary_exits: :math.pow(2, 4),

    # Domain types
    domain_beacon_proposer: 0x00000000,
    domain_beacon_attester: 0x01000000,
    domain_randao: 0x02000000,
    domain_voluntary_exit: 0x04000000,
    domain_selection_proof: 0x05000000,
    domain_aggregate_and_proof: 0x06000000
  ]

  for {key, value} <- values do
    def decode(unquote(key)), do: unquote(value)
  end
end
