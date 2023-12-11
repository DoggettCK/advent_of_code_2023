defmodule Common do
  def string_to_integers(line) do
    ~r/-?\d+/
    |> Regex.scan(line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
