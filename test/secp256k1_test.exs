defmodule Secp256k1Test do
  use ExUnit.Case

  alias Secp256k1.{Curve, Point, Secp256k1Curve, Secp256k1Generator}

  describe "Secp256k1Generator" do
    test "initializes generator point for Secp256k1" do
      assert %Point{} = Secp256k1Generator.new()
    end
  end

  describe "Secp256k1Curve" do
    test "contains secp256k1 generator point" do
      curve = Secp256k1Curve.new()
      generator = Secp256k1Generator.new()
      assert Curve.contains(curve, generator)
    end
  end
end
