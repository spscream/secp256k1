  defmodule Secp256k1.Curve do
    alias Secp256k1.Point

    defstruct [:p, :a, :b]

    def contains(curve, %Point{x: x, y: y}) do
      contains(curve, x, y)
    end

    def contains(curve, x, y) do
      rem((y * y - (x * x * x + curve.a * x + curve.b)), curve.p) == 0
    end
  end
