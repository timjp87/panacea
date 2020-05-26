defmodule Beacon.State.Block do
  @moduledoc """
  Defines the structure of a beacon chain block and its methods.
  """
  use TypedStruct

  alias Beacon.State.{
    Eth1Data,
    Attestation,
    Transfer,
    Deposit,
    VoluntaryExit,
    Block,
    Slashing
  }

  defmodule Header do
    @moduledoc """
    This his the header of a block in the beacon chain in Ethereum 2.0.
    """
    typedstruct do
      field(:slot, non_neg_integer(), enforce: true)
      field(:previous_slot, <<_::256>>, enforce: true)
      field(:state_root, <<_::256>>, enforce: true)
      field(:body, Block.Body.t(), enforce: true)
      field(:signature, <<_::768>>, enforce: true)
    end
  end

  defmodule Body do
    @moduledoc """
    Defines the block mody of a beacon chain block.
    """
    typedstruct do
      field(:rando_reveal, <<>>, enforce: true)
      field(:eth1_data, Eth1Data.t(), enforce: true)
      field(:proposer_slashings, [Slashing.ProposorSlashing.t()], enforce: true)
      field(:attester_slashings, [Slashing.AttesterSlashing.t()], enforce: true)
      field(:attestations, [Attestation.t()], enforce: true)
      field(:deposits, [Deposit.t()], enforce: true)
      field(:voluntary_exits, [VoluntaryExit.t()], enforce: true)
      field(:transfers, [Transfer.t()], enforce: true)
    end
  end
end
