defmodule Day1 do
  @numbers %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def part_one(input) do
    input
    |> Enum.map(&first_and_last/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Enum.map(&first_and_last_number_or_word/1)
    |> Enum.sum()
  end

  defp first_and_last(str) do
    str
    |> String.graphemes()
    |> first_and_last(-1, -1)
  end

  defp first_and_last([], first, last), do: first * 10 + last

  defp first_and_last([c | rest], first, last) do
    case Integer.parse(c) do
      :error ->
        first_and_last(rest, first, last)

      {d, _} ->
        if first == -1 do
          first_and_last(rest, d, d)
        else
          first_and_last(rest, first, d)
        end
    end
  end

  defp first_and_last_number_or_word(str) do
    first_and_last_number_or_word(str, -1, -1)
  end

  defp first_and_last_number_or_word("", first, last), do: first * 10 + last

  for {s, d} <- @numbers do
    defp first_and_last_number_or_word(unquote(s) <> rest, first, _last) do
      # use the word, but put all but the first character back on the rest of
      # the string to catch things like oneight, sevenine, etc...
      <<_::binary-size(1), rest_of_match::binary>> = unquote(s)

      if first == -1 do
        first_and_last_number_or_word(rest_of_match <> rest, unquote(d), unquote(d))
      else
        first_and_last_number_or_word(rest_of_match <> rest, first, unquote(d))
      end
    end
  end

  defp first_and_last_number_or_word(<<_::binary-size(1), rest::binary>>, first, last) do
    first_and_last_number_or_word(rest, first, last)
  end
end
