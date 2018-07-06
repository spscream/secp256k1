defmodule Secp256k1.Infinity do
  alias Secp256k1.Point

  def new do
    %Point{x: :infinity, y: :infinity}
  end
end
