defmodule Beacon.State.Fork do
  use TypedStruct

  typedstruct do
    field(:previous_version, <<_::32>>, enforce: true)
    field(:current_version, <<_::32>>, enforce: true)
    field(:epoch, non_neg_integer(), enforce: true)
  end
end
