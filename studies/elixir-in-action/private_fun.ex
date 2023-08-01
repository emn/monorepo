defmodule TestPrivate do
  @spec double(number) :: number
  def double(a) do
    sum(a, a)
  end

  @spec sum(number, number) :: number
  defp sum(a, b) do
    a + b
  end
end
