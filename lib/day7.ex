defmodule Day7 do
  @card_scores "23456789TJQKA"
               |> String.graphemes()
               |> Enum.with_index(2)
               |> Enum.into(%{})

  @card_scores_with_jokers "J23456789TQKA"
                           |> String.graphemes()
                           |> Enum.with_index(2)
                           |> Enum.into(%{})

  @five_of_a_kind 0
  @four_of_a_kind 1
  @full_house 2
  @three_of_a_kind 3
  @two_pair 4
  @one_pair 5
  @high_card 6

  def part_one(input) do
    input
    |> Enum.map(&parse_hand/1)
    |> Enum.sort(&hand_sorter/2)
    |> Enum.map(& &1.bid)
    |> Enum.with_index(1)
    |> Enum.map(fn {bid, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Enum.map(&parse_hand/1)
    |> Enum.sort(&hand_sorter_with_jokers/2)
    |> Enum.map(& &1.bid)
    |> Enum.with_index(1)
    |> Enum.map(fn {bid, rank} -> bid * rank end)
    |> Enum.sum()
  end

  defp parse_hand(line) do
    [hand, bid] = String.split(line)

    cards = String.graphemes(hand)

    %{
      cards: Enum.map(cards, &Map.get(@card_scores, &1)),
      cards_with_jokers: Enum.map(cards, &Map.get(@card_scores_with_jokers, &1)),
      bid: String.to_integer(bid),
      type: hand_type(cards),
      type_with_jokers: hand_type_with_jokers(cards)
    }
  end

  defp hand_type(cards) do
    cards
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort()
    |> case do
      [1, 1, 1, 1, 1] -> @high_card
      [1, 1, 1, 2] -> @one_pair
      [1, 1, 3] -> @three_of_a_kind
      [1, 2, 2] -> @two_pair
      [1, 4] -> @four_of_a_kind
      [2, 3] -> @full_house
      [5] -> @five_of_a_kind
    end
  end

  defp hand_type_with_jokers(cards) do
    frequencies = Enum.frequencies(cards)

    case Map.pop(frequencies, "J") do
      {nil, _} ->
        # No jokers, just use regular type calculation
        hand_type(cards)

      {joker_count, remaining} ->
        remaining
        |> Map.values()
        |> Enum.sort()
        |> case do
          # 1 joker
          [1, 1, 1, 1] -> @one_pair
          # 2 jokers
          [1, 1, 1] -> @three_of_a_kind
          # 1 joker
          [1, 1, 2] -> @three_of_a_kind
          # 3 jokers
          [1, 1] -> @four_of_a_kind
          # 2 jokers
          [1, 2] -> @four_of_a_kind
          # 1 joker
          [1, 3] -> @four_of_a_kind
          # 1 joker
          [2, 2] -> @full_house
          # 5 jokers
          [] -> @five_of_a_kind
          # 4 jokers
          [1] -> @five_of_a_kind
          # 3 jokers
          [2] -> @five_of_a_kind
          # 2 jokers
          [3] -> @five_of_a_kind
          # 1 joker
          [4] -> @five_of_a_kind
        end
    end
  end

  defp hand_sorter(%{type: type} = hand1, %{type: type} = hand2) do
    hand1.cards <= hand2.cards
  end

  defp hand_sorter(hand1, hand2), do: hand1.type > hand2.type

  defp hand_sorter_with_jokers(
         %{type_with_jokers: type} = hand1,
         %{type_with_jokers: type} = hand2
       ) do
    hand1.cards_with_jokers <= hand2.cards_with_jokers
  end

  defp hand_sorter_with_jokers(hand1, hand2), do: hand1.type_with_jokers > hand2.type_with_jokers
end
