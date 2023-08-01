defmodule RecursionPractice do
  @spec list_len(list) :: number
  def list_len(l) do
    list_len_rec(l, 0)
  end

  @spec list_len_rec(list, number) :: number
  defp list_len_rec([], a), do: a

  defp list_len_rec(l, a) do
    1 + list_len_rec(tl(l), a)
  end

  @spec range(number, number) :: list
  def range(f, t) do
    range_rec(f, t, [f])
  end

  @spec range_rec(number, number, list) :: list
  defp range_rec(f, t, a) when f == t, do: a

  defp range_rec(f, t, a) do
    a ++ range_rec(f + 1, t, [f + 1])
  end

  @spec positive(list) :: list
  def positive(l) do
    positive_rec(l, [])
  end

  @spec positive_rec(list, list) :: list
  defp positive_rec([], l2), do: l2

  defp positive_rec(l, l2) when hd(l) > 0 do
    l2 ++ positive_rec(tl(l), [hd(l)])
  end

  defp positive_rec(l, l2), do: l2 ++ positive_rec(tl(l), [])
end
