defmodule Beacon.State.Slashing do
  @moduledoc """
  Defindes the behavior of the different slashing mechanisms.
  """
  use TypedStruct

  alias Beacon.State.{Block, Attestation.IndexedAttestation}

  defmodule ProposerSlashing do
    @moduledoc """
    Encodes the slashing of block proposers.
    """

    typedstruct do
      field(:proposer_index, non_neg_integer(), enforce: true)
      field(:header_1, Block.Header.t(), enforce: true)
      field(:header_2, Block.Header.t(), enforce: true)
    end

    defmodule AttesterSlashing do
      @moduledoc """
      Encodes the data structure for attester slashing.
      """

      typedstruct do
        field(:attestation_1, IndexedAttestation.t(), enforce: true)
        field(:attestation_2, IndexedAttestation.t(), enforce: true)
      end
    end
  end
end
