defmodule Beacon.State.Deposit do
  @moduledoc """
  Defines a deposit.
  """
  use TypedStruct

  alias Beacon.State.Deposit

  typedstruct do
    field(:proof, <<_::256>>, enforce: true)
    field(:index, non_neg_integer(), enforce: true)
    field(:data, Deposit.Data.t(), enforce: true)
  end

  defmodule Data do
    @moduledoc """
    The deposit data.
    """

    typedstruct do
      field(:pubkey, <<_::384>>, enforce: true)
      field(:withdrawal_credentials, <<_::256>>, enforce: true)
      field(:amount, non_neg_integer(), enforce: true)
      field(:signature, <<_::768>>, enforce: true)
    end
  end
end
