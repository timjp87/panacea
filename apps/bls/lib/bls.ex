defmodule Bls do
  @moduledoc """
  Wrapper around the BLS 12-381 eliptic curve contruction and signature scheme in Rust by SigmaPrime.
  """
  use Rustler, otp_app: :bls, crate: "bls"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
  def new_kp(), do: :erlang.nif_error(:nif_not_loaded)
  def sign(_msg, _d, _sk), do: :erlang.nif_error(:nif_not_loaded)
  def verify(_sig, _msg, _d, _pk), do: :erlang.nif_error(:nif_not_loaded)
  def new_sk(), do: :erlang.nif_error(:nif_not_loaded)
  def new_sk_from_bytes(_bytes), do: :erlang.nif_error(:nif_not_loaded)
  def sk_to_bytes(_pk), do: :erlang.nif_error(:nif_not_loaded)

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

    def verify(sig, msg, d, pk) when is_atom(msg) do
      msg = :binary.bin_to_list(msg)
      Bls.verify(sig, msg, d, pk)
    end

    def verify(sig, msg, d, pk) when is_binary(msg) do
      msg = :binary.bin_to_list(msg)
      Bls.verify(sig, msg, d, pk)
    end

    def verify(sig, msg, d, pk) when is_bitstring(msg) do
      msg = :binary.bin_to_list(msg)
      Bls.verify(sig, msg, d, pk)
    end

    def verify(sig, msg, d, pk) when is_number(msg) do
      msg = Enum.into(msg, [])
      Bls.verify(sig, msg, d, pk)
    end

    def verify(sig, msg, d, pk), do: Bls.verify(sig, msg, d, pk)
  end

  defmodule Keys do
    @moduledoc """
    Module for generating public and private keys in various ways.
    """

    defmodule SecretKey do
      @moduledoc """
      Lets you create new secret key from randomness or seeded with 48 bytes.
      """

      def new() do
        Bls.new_sk()
      end

      def from_bytes(bytes) when is_binary(bytes) do
        bytes |> :binary.bin_to_list() |> Bls.new_sk_from_bytes()
      end

      def from_bytes(bytes) do
        bytes |> Bls.new_sk_from_bytes()
      end

      def as_bytes(pk) do
        Bls.sk_to_bytes(pk)
      end
    end

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
