defmodule Ethereum.Beacon.Rpc.V1.ValidatorPerformanceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          slot: non_neg_integer,
          public_key: binary
        }
  defstruct [:slot, :public_key]

  field :slot, 1, type: :uint64
  field :public_key, 2, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorPerformanceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          balance: non_neg_integer,
          total_validators: non_neg_integer,
          total_active_validators: non_neg_integer,
          average_validator_balance: float
        }
  defstruct [:balance, :total_validators, :total_active_validators, :average_validator_balance]

  field :balance, 1, type: :uint64
  field :total_validators, 2, type: :uint64
  field :total_active_validators, 3, type: :uint64
  field :average_validator_balance, 4, type: :float
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorActivationRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          public_keys: [binary]
        }
  defstruct [:public_keys]

  field :public_keys, 1, repeated: true, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorActivationResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          activated_public_keys: [binary]
        }
  defstruct [:activated_public_keys]

  field :activated_public_keys, 1, repeated: true, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.AttestationDataRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          shard: non_neg_integer,
          slot: non_neg_integer
        }
  defstruct [:shard, :slot]

  field :shard, 1, type: :uint64
  field :slot, 2, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.AttestationDataResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          beacon_block_root_hash32: binary,
          epoch_boundary_root_hash32: binary,
          justified_epoch: non_neg_integer,
          justified_block_root_hash32: binary,
          latest_crosslink: Ethereum.Beacon.P2p.V1.Crosslink.t() | nil,
          head_slot: non_neg_integer
        }
  defstruct [
    :beacon_block_root_hash32,
    :epoch_boundary_root_hash32,
    :justified_epoch,
    :justified_block_root_hash32,
    :latest_crosslink,
    :head_slot
  ]

  field :beacon_block_root_hash32, 1, type: :bytes
  field :epoch_boundary_root_hash32, 2, type: :bytes
  field :justified_epoch, 3, type: :uint64
  field :justified_block_root_hash32, 4, type: :bytes
  field :latest_crosslink, 5, type: Ethereum.Beacon.P2p.V1.Crosslink
  field :head_slot, 6, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.PendingAttestationsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          filter_ready_for_inclusion: boolean,
          proposal_block_slot: non_neg_integer
        }
  defstruct [:filter_ready_for_inclusion, :proposal_block_slot]

  field :filter_ready_for_inclusion, 1, type: :bool
  field :proposal_block_slot, 2, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.PendingAttestationsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pending_attestations: [Ethereum.Beacon.P2p.V1.Attestation.t()]
        }
  defstruct [:pending_attestations]

  field :pending_attestations, 1, repeated: true, type: Ethereum.Beacon.P2p.V1.Attestation
end

defmodule Ethereum.Beacon.Rpc.V1.ChainStartResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          started: boolean,
          genesis_time: non_neg_integer
        }
  defstruct [:started, :genesis_time]

  field :started, 1, type: :bool
  field :genesis_time, 2, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.ProposeRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          parent_hash: binary,
          slot_number: non_neg_integer,
          randao_reveal: binary,
          attestation_bitmask: binary,
          attestation_aggregate_sig: [non_neg_integer],
          timestamp: Google.Protobuf.Timestamp.t() | nil
        }
  defstruct [
    :parent_hash,
    :slot_number,
    :randao_reveal,
    :attestation_bitmask,
    :attestation_aggregate_sig,
    :timestamp
  ]

  field :parent_hash, 1, type: :bytes
  field :slot_number, 2, type: :uint64
  field :randao_reveal, 3, type: :bytes
  field :attestation_bitmask, 4, type: :bytes
  field :attestation_aggregate_sig, 5, repeated: true, type: :uint64
  field :timestamp, 6, type: Google.Protobuf.Timestamp
end

defmodule Ethereum.Beacon.Rpc.V1.ProposeResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          block_root_hash32: binary
        }
  defstruct [:block_root_hash32]

  field :block_root_hash32, 1, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.ProposerIndexRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          slot_number: non_neg_integer
        }
  defstruct [:slot_number]

  field :slot_number, 1, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.ProposerIndexResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          index: non_neg_integer
        }
  defstruct [:index]

  field :index, 1, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.StateRootResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          state_root: binary
        }
  defstruct [:state_root]

  field :state_root, 1, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.AttestResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attestation_hash: binary
        }
  defstruct [:attestation_hash]

  field :attestation_hash, 1, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorIndexRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          public_key: binary
        }
  defstruct [:public_key]

  field :public_key, 1, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorIndexResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          index: non_neg_integer
        }
  defstruct [:index]

  field :index, 1, type: :uint64
end

defmodule Ethereum.Beacon.Rpc.V1.CommitteeAssignmentsRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          epoch_start: non_neg_integer,
          public_keys: [binary]
        }
  defstruct [:epoch_start, :public_keys]

  field :epoch_start, 1, type: :uint64
  field :public_keys, 2, repeated: true, type: :bytes
end

defmodule Ethereum.Beacon.Rpc.V1.PendingDepositsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pending_deposits: [Ethereum.Beacon.P2p.V1.Deposit.t()]
        }
  defstruct [:pending_deposits]

  field :pending_deposits, 1, repeated: true, type: Ethereum.Beacon.P2p.V1.Deposit
end

defmodule Ethereum.Beacon.Rpc.V1.CommitteeAssignmentResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          assignment: [Ethereum.Beacon.Rpc.V1.CommitteeAssignmentResponse.CommitteeAssignment.t()]
        }
  defstruct [:assignment]

  field :assignment, 1,
    repeated: true,
    type: Ethereum.Beacon.Rpc.V1.CommitteeAssignmentResponse.CommitteeAssignment
end

defmodule Ethereum.Beacon.Rpc.V1.CommitteeAssignmentResponse.CommitteeAssignment do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          committee: [non_neg_integer],
          shard: non_neg_integer,
          slot: non_neg_integer,
          is_proposer: boolean,
          public_key: binary,
          status: atom | integer
        }
  defstruct [:committee, :shard, :slot, :is_proposer, :public_key, :status]

  field :committee, 1, repeated: true, type: :uint64
  field :shard, 2, type: :uint64
  field :slot, 3, type: :uint64
  field :is_proposer, 4, type: :bool
  field :public_key, 5, type: :bytes
  field :status, 6, type: Ethereum.Beacon.Rpc.V1.ValidatorStatus, enum: true
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorStatusResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          status: atom | integer
        }
  defstruct [:status]

  field :status, 1, type: Ethereum.Beacon.Rpc.V1.ValidatorStatus, enum: true
end

defmodule Ethereum.Beacon.Rpc.V1.Eth1DataResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          eth1_data: Ethereum.Beacon.P2p.V1.Eth1Data.t() | nil
        }
  defstruct [:eth1_data]

  field :eth1_data, 1, type: Ethereum.Beacon.P2p.V1.Eth1Data
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorRole do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :UNKNOWN, 0
  field :ATTESTER, 1
  field :PROPOSER, 2
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorStatus do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :UNKNOWN_STATUS, 0
  field :PENDING_ACTIVE, 1
  field :ACTIVE, 2
  field :INITIATED_EXIT, 3
  field :WITHDRAWABLE, 4
  field :EXITED, 5
  field :EXITED_SLASHED, 6
end

defmodule Ethereum.Beacon.Rpc.V1.BeaconService.Service do
  @moduledoc false
  use GRPC.Service, name: "ethereum.beacon.rpc.v1.BeaconService"

  rpc :WaitForChainStart, Google.Protobuf.Empty, stream(Ethereum.Beacon.Rpc.V1.ChainStartResponse)
  rpc :CanonicalHead, Google.Protobuf.Empty, Ethereum.Beacon.P2p.V1.BeaconBlock
  rpc :LatestAttestation, Google.Protobuf.Empty, stream(Ethereum.Beacon.P2p.V1.Attestation)
  rpc :PendingDeposits, Google.Protobuf.Empty, Ethereum.Beacon.Rpc.V1.PendingDepositsResponse
  rpc :Eth1Data, Google.Protobuf.Empty, Ethereum.Beacon.Rpc.V1.Eth1DataResponse
  rpc :ForkData, Google.Protobuf.Empty, Ethereum.Beacon.P2p.V1.Fork
end

defmodule Ethereum.Beacon.Rpc.V1.BeaconService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Ethereum.Beacon.Rpc.V1.BeaconService.Service
end

defmodule Ethereum.Beacon.Rpc.V1.AttesterService.Service do
  @moduledoc false
  use GRPC.Service, name: "ethereum.beacon.rpc.v1.AttesterService"

  rpc :AttestHead, Ethereum.Beacon.P2p.V1.Attestation, Ethereum.Beacon.Rpc.V1.AttestResponse

  rpc :AttestationDataAtSlot,
      Ethereum.Beacon.Rpc.V1.AttestationDataRequest,
      Ethereum.Beacon.Rpc.V1.AttestationDataResponse
end

defmodule Ethereum.Beacon.Rpc.V1.AttesterService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Ethereum.Beacon.Rpc.V1.AttesterService.Service
end

defmodule Ethereum.Beacon.Rpc.V1.ProposerService.Service do
  @moduledoc false
  use GRPC.Service, name: "ethereum.beacon.rpc.v1.ProposerService"

  rpc :ProposerIndex,
      Ethereum.Beacon.Rpc.V1.ProposerIndexRequest,
      Ethereum.Beacon.Rpc.V1.ProposerIndexResponse

  rpc :PendingAttestations,
      Ethereum.Beacon.Rpc.V1.PendingAttestationsRequest,
      Ethereum.Beacon.Rpc.V1.PendingAttestationsResponse

  rpc :ProposeBlock, Ethereum.Beacon.P2p.V1.BeaconBlock, Ethereum.Beacon.Rpc.V1.ProposeResponse

  rpc :ComputeStateRoot,
      Ethereum.Beacon.P2p.V1.BeaconBlock,
      Ethereum.Beacon.Rpc.V1.StateRootResponse
end

defmodule Ethereum.Beacon.Rpc.V1.ProposerService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Ethereum.Beacon.Rpc.V1.ProposerService.Service
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorService.Service do
  @moduledoc false
  use GRPC.Service, name: "ethereum.beacon.rpc.v1.ValidatorService"

  rpc :WaitForActivation,
      Ethereum.Beacon.Rpc.V1.ValidatorActivationRequest,
      stream(Ethereum.Beacon.Rpc.V1.ValidatorActivationResponse)

  rpc :ValidatorIndex,
      Ethereum.Beacon.Rpc.V1.ValidatorIndexRequest,
      Ethereum.Beacon.Rpc.V1.ValidatorIndexResponse

  rpc :CommitteeAssignment,
      Ethereum.Beacon.Rpc.V1.CommitteeAssignmentsRequest,
      Ethereum.Beacon.Rpc.V1.CommitteeAssignmentResponse

  rpc :ValidatorStatus,
      Ethereum.Beacon.Rpc.V1.ValidatorIndexRequest,
      Ethereum.Beacon.Rpc.V1.ValidatorStatusResponse

  rpc :ValidatorPerformance,
      Ethereum.Beacon.Rpc.V1.ValidatorPerformanceRequest,
      Ethereum.Beacon.Rpc.V1.ValidatorPerformanceResponse
end

defmodule Ethereum.Beacon.Rpc.V1.ValidatorService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Ethereum.Beacon.Rpc.V1.ValidatorService.Service
end
