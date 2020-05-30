defmodule BeaconWeb.Metrics.BeaconInstrumenter do
  @moduledoc """
  Beaconchain metrics
  """

  use Prometheus.Metric

  require Logger

  def setup() do
    Gauge.declare(
      name: :beacon_slot,
      help: "Latest slot of the beacon chain state."
    )

    Gauge.declare(
      name: :beacon_head_slot,
      help: "Slot of the head block of the beacon chain."
    )

    Gauge.declare(
      name: :beacon_head_root,
      help: "Root of the head block of the beacon chain."
    )

    Gauge.declare(
      name: :beacon_finalized_epoch,
      help: "Current finalized epoch."
    )

    Gauge.declare(
      name: :beacon_finalized_root,
      help: "Current finalized root."
    )

    Gauge.declare(
      name: :beacon_current_justified_epoch,
      help: "Current justified epoch"
    )

    Gauge.declare(
      name: :beacon_current_justified_root,
      help: "Current justified root"
    )

    Gauge.declare(
      name: :beacon_previous_justified_epoch,
      help: "Current previously justified epoch."
    )

    Gauge.declare(
      name: :beacon_previous_justified_root,
      help: "Current previously justified root."
    )

    Gauge.declare(
      name: :beacon_current_validators,
      help: "Number of status=pending|active|exited|withdrawable validators in current epoch."
    )

    Gauge.declare(
      name: :beacon_previous_validators,
      help: "Number of status=pending|active|exited|withdrawable validators in previous epoch."
    )

    Gauge.declare(
      name: :beacon_current_live_validators,
      help:
        "Number of active validators that successfully included attestation on chain for current epoch."
    )

    Gauge.declare(
      name: :beacon_previous_live_validators,
      help:
        "Number of active validators that successfully included attestation on chain for previous epoch."
    )

    Gauge.declare(
      name: :beacon_pending_deposits,
      help:
        "Number of pending deposits (state.eth1_data.deposit_count - state.eth1_deposit_index)."
    )

    Gauge.declare(
      name: :beacon_processed_deposits_total,
      help: "Number of total deposits included on chain."
    )

    Gauge.declare(
      name: :beacon_pending_exits,
      help: "Number of pending voluntary exits in local operation pool."
    )

    Gauge.declare(
      name: :beacon_previous_epoch_orphaned_blocks,
      help: "Number of blocks orphaned in the previous epoch."
    )

    Counter.declare(
      name: :beacon_reorgs_total,
      help: "Total occurrences of reorganizations of the chain."
    )
  end
end
