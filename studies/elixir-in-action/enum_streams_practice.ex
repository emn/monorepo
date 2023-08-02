defmodule EnumStreamsPractice do
  @spec lines_lengths!(String.t()) :: list
  def lines_lengths!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(fn x -> String.length(x) end)
  end

  @spec longest_line_length!(String.t()) :: number
  def longest_line_length!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  @spec longest_line!(String.t()) :: String.t()
  def longest_line!(path) do
    f = fn x, a ->
      if String.length(x) > elem(a, 0) do
        {String.length(x), x}
      else
        a
      end
    end

    {_, r} =
      path
      |> File.stream!()
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.reduce({0, ""}, f)

    r
  end

  @spec words_per_line!(String.t()) :: list
  def words_per_line!(path) do
    path
    |> File.stream!()
    |> Enum.map(&(length(String.split(&1)) / 1))
  end
end
