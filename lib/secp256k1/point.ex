defmodule Secp256k1.Point do
  use Bitwise
  alias Secp256k1.{Curve, Point, Infinity}

  defstruct [:curve, :x, :y, :order]

  def new(curve, x, y, order \\ nil) do
    if Curve.contains(curve, x, y) do
      %Point{curve: curve, x: x, y: y, order: order}
    else
      raise "Point isn't on the specified curve"
    end
  end

  def add(%Point{x: :infinity, y: :infinity}, p2), do: p2
  def add(p1, %Point{x: :infinity, y: :infinity}), do: p1
  def add(%Point{curve: curve1}, %Point{curve: curve2}) when curve1 != curve2 do
    raise "Points on different curves"
  end
  def add(%Point{x: x1}= p1, %Point{x: x2} = p2) when x1 == x2 do
    if rem((p1.y + p2.y), p1.curve.p) == 0 do
      Infinity.new()
    else
      double(p1)
    end
  end
  def add(p1, p2) do
    p = p1.curve.p
    l = rem(((p2.y - p1.y) * inverse_mod(p2.x - p1.x, p)), p)
    x3 = rem((l * l - p1.x - p2.x), p)
    y3 = rem((l * (p1.x - x3) - p1.y), p)
    Point.new(p1.curve, x3, y3)
  end

  def mult(%Point{order: nil} = left, right), do: compute_mult(left, right)
  def mult(%Point{order: order} = left, right), do: compute_mult(left, rem(right, order))
  def mult(left, %Point{} = right), do: mult(right, left)

  defp compute_mult(_left, 0), do: Infinity.new()
  defp compute_mult(%Point{x: :infinity, y: :infinity} = p, _), do: p
  defp compute_mult(left, e) do
    e3 = 3 * e
    negative_left = Point.new(left.curve, left.x, -left.y)
    i = trunc(leftmost_bit(e3) / 2)

    compute_mult(left, i, e3, e, left, negative_left)
  end
  defp compute_mult(result, i, e3, e, left, negative_left) when i > 1 do
    result = Point.double(result)
    result = cond do
      band(e3, i) != 0 && band(e, i) == 0 -> Point.add(result, left)
      band(e3, i) == 0 && band(e, i) != 0 -> Point.add(result, negative_left)
      true -> result
    end

    compute_mult(result, trunc(i / 2), e3, e, left, negative_left)
  end
  defp compute_mult(result, _i, _e3, _e, _left, _negative_left) do
    result
  end

  def double(%Point{x: :infinity, y: :infinity} = p), do: p
  def double(point) do
    p = point.curve.p
    a = point.curve.a
    l = rem(((3 * point.x * point.x + a) * inverse_mod(2 * point.y, p)), p)
    x3 = rem((l * l - 2 * point.x), p)
    y3 = rem((l * (point.x - x3) - point.y), p)
    Point.new(point.curve, x3, y3)
  end

  def inverse_mod(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise "The maths are broken!"
    rem(x+et, et)
  end

  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * (if a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}
  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient   = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient*x, y, last_y - quotient*y)
  end

  def leftmost_bit(x) when x <= 0, do: raise "x must be > 0"
  def leftmost_bit(x), do: leftmost_bit(x, 1)

  defp leftmost_bit(x, result) when result <= x, do: leftmost_bit(x, 2 * result)
  defp leftmost_bit(_x, result), do: trunc(result / 2)
end

