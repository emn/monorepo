defmodule RecursionPracticeTc do
  @spec list_len(list) :: number
  def list_len(l) do
    list_len_tc(l, 0)
  end

  @spec list_len_tc(list, number) :: number
  defp list_len_tc([], a), do: a

  defp list_len_tc(l, a) do
    list_len_tc(tl(l), a + 1)
  end

  @spec range(number, number) :: list
  def range(f, t) do
    range_tc(f, t, [f])
  end

  @spec range_tc(number, number, list) :: list
  def range_tc(f, t, a) when f == t, do: a

  def range_tc(f, t, a) do
    range_tc(f + 1, t, a ++ [f + 1])
  end

  @spec positive(list) :: list
  def positive(l) do
    positive_tc(l, [])
  end

  @spec positive_tc(list, list) :: list
  defp positive_tc([], l2), do: l2

  defp positive_tc(l, l2) when hd(l) > 0 do
    positive_tc(tl(l), l2 ++ [hd(l)])
  end

  defp positive_tc(l, l2) do
    positive_tc(tl(l), l2 ++ [])
  end
end
