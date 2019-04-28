defmodule Bls do
  @moduledoc """
  Wrapper around the BLS 12-381 eliptic curve contruction and signature scheme in Rust by SigmaPrime.
  """
  use Rustler, otp_app: :bls, crate: "bls"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
  def new_kp(), do: :erlang.nif_error(:nif_not_loaded)
  def sign(_msg, _d, _sk), do: :erlang.nif_error(:nif_not_loaded)

  defmodule Signature do
    @moduledoc """
    Module for signing, aggregating and verifying BLS signatures.
    """
    def sign(msg, d, sk) when is_atom(msg), do: msg |> Atom.to_charlist() |> Bls.sign(d, sk)
    def sign(msg, d, sk) when is_binary(msg), do: msg |> :binary.bin_to_list() |> Bls.sign(d, sk)

    def sign(msg, d, sk) when is_bitstring(msg),
      do: msg |> :binary.bin_to_list() |> Bls.sign(d, sk)

    def sign(msg, d, sk) when is_number(msg), do: msg |> Enum.into([] |> Bls.sign(d, sk))
    def sign(msg, d, sk), do: Bls.sign(msg, d, sk)
  end

  defmodule Keys do
    @moduledoc """
    Module for generating public and private keys in various ways.
    """
    defmodule Keypair do
      @moduledoc """
      Module for generating a new keypair.
      """
      defstruct [:secret_key, :public_key]

      def new() do
        {sk, pk} = Bls.new_kp()
        %Keypair{secret_key: sk, public_key: pk}
      end
    end
  end

  def hello() do
    :world
  end
end
