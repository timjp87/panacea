defmodule Bls do
  @moduledoc """
  Wrapper around the BLS 12-381 eliptic curve contruction and signature scheme in Rust by SigmaPrime.
  """
  use Rustler, otp_app: :bls, crate: "bls"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  def hello() do
    :world
  end
end
