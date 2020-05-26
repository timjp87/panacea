defmodule Beacon.State.Attestation do
  @moduledoc """
  This module defines an Attestiation in the beacon chain.
  """
  use TypedStruct

  alias Beacon.State.Attestation

  typedstruct do
    field(:aggregation_bitfield, <<>>, enforce: true)
    field(:data, Attestation.Data.t(), enforce: true)
    field(:custody_bitfield, <<>>, enforce: true)
    field(:signature, <<_::768>>, enforce: true)
  end

  defmodule Data do
    @moduledoc """
    Defines the data structure of an attestation.
    """
    typedstruct do
      # LMD GHOST vote
      field(:slot, non_neg_integer(), enforce: true)
      field(:beacon_block_root, <<_::256>>, enforce: true)

      # FFG vote
      field(:source_epoch, non_neg_integer(), enforce: true)
      field(:source_root, <<_::256>>, enforce: true)
      field(:target_root, <<_::256>>, enforce: true)

      # Crosslink vote
      field(:shard, non_neg_integer(), enforce: true)
      field(:previous_crosslink_root, <<_::256>>, enforce: true)
      field(:crosslink_data_root, <<_::256>>, enforce: true)
    end
  end

  defmodule CustodyBit do
    @moduledoc """
    TODO
    """
    typedstruct do
      field(:data, Attestation.Data.t(), enforce: true)
      field(:custody_bit, boolean(), enforce: true)
    end
  end

  defmodule IndexedAttestation do
    @moduledoc """
    TODO
    """
    typedstruct do
      field(:custody_bit_0_indices, [non_neg_integer()], enforce: true)
      field(:custody_bit_1_indices, [non_neg_integer()], enforce: true)
      field(:signature, <<_::768>>, enforce: true)
    end
  end

  defmodule PendingAttestation do
    @moduledoc """
    Encodes a pending attestation.
    """

    typedstruct do
      field(:aggreation_bitfield, <<>>, enforce: true)
      field(:data, Attestation.Data.t(), enforce: true)
      field(:inclusion_slot, non_neg_integer(), enforce: true)
    end
  end
end
