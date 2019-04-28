defmodule Bls do
  @moduledoc """
  Wrapper around the BLS 12-381 eliptic curve contruction and signature scheme in Rust by SigmaPrime.
  """
  use Rustler, otp_app: :bls, crate: "bls"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
  def new_kp(), do: :erlang.nif_error(:nif_not_loaded)

  defmodule Keypair do
    defstruct [:secret_key, :public_key]

    def new() do
      {sk, pk} = Bls.new_kp()
      %Keypair{secret_key: sk, public_key: pk}
    end
  end

  def hello() do
    :world
  end
end
