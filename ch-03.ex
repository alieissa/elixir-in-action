defmodule StreamsT do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(fn line -> String.trim_trailing(line, "\n") end)
    |> Enum.filter(fn line -> String.length(line) > 80 end)
  end

  def line_lengths!(path) do
    File.stream!(path)
    |> Stream.map(fn ln -> String.trim_trailing(ln, "\n") end)
    |> Enum.map(fn ln -> String.length(ln) end)
  end

  def longest_line_length!(path) do
    lengths = line_lengths!(path)
    Enum.max(lengths)
  end

  def longest_line!(path) do
    longest_line = longest_line_length!(path)

    [head] =
      File.stream!(path)
      |> Stream.map(fn ln -> String.trim_trailing(ln, "\n") end)
      |> Enum.reject(fn ln -> String.length(ln) < longest_line end)

    head
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(fn ln -> String.trim_trailing(ln, "\n") end)
    |> Enum.map(fn ln -> length(String.split(ln)) end)
  end
end

defmodule RecT do
  def aux(ls, ln) do
    case ls do
      [] -> ln
      [_] -> aux([], ln + 1)
      [_ | tail] -> aux(tail, ln + 1)
    end
  end

  def list_len(lst) do
    aux(lst, 0)
  end

  def raux(lst, from, to) do
    if(from > to) do
      lst
    else
      raux(lst ++ [from], from + 1, to)
    end

  end
  def range(from, to) do
   raux([], from, to)
  end

  def positive([], lst), do: lst
  def positive([head | tail], lst) when head > 0, do: positive(tail, lst ++ [head])
  def positive([head | tail], lst) when head <= 0, do: positive(tail, lst)
  def positive(lst), do: positive(lst, [])
end
