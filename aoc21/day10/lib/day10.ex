defmodule DAY10 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> results()
    |> Enum.reduce(%{}, fn value, acc ->
      Map.update(acc, value, 1, fn current_value -> current_value + 1 end)
    end)
    |> Enum.reduce(0, fn {k, v}, acc ->
      acc + v * match(k)
    end)
  end

  def results(list) do
    Enum.reduce(list, [], fn line, acc ->
      s = Structure.Stack.new()

      {_, value} =
        Enum.reduce_while(String.graphemes(line), {s, ""}, fn char, {stack, acc} ->
          res =
            case char do
              "(" -> Structure.Stack.push(stack, char)
              "[" -> Structure.Stack.push(stack, char)
              "{" -> Structure.Stack.push(stack, char)
              "<" -> Structure.Stack.push(stack, char)
              ")" -> Structure.Stack.pop(stack)
              "]" -> Structure.Stack.pop(stack)
              "}" -> Structure.Stack.pop(stack)
              ">" -> Structure.Stack.pop(stack)
            end

          case res do
            {:error, :empty_stack} ->
              {:halt, {stack, acc}}

            {:ok, new_stack} ->
              sp = Kernel.elem(Structure.Stack.head(stack), 1)

              case {sp, char} do
                {"(", ")"} -> {:cont, {new_stack, acc}}
                {"[", "]"} -> {:cont, {new_stack, acc}}
                {"<", ">"} -> {:cont, {new_stack, acc}}
                {"{", "}"} -> {:cont, {new_stack, acc}}
                _ -> {:halt, {stack, char}}
              end

            _ ->
              {:cont, {res, acc}}
          end
        end)

      [value | acc]
    end)
    |> Enum.filter(fn char -> char != "" end)
  end

  def match(char) do
    case char do
      ")" ->
        3

      "]" ->
        57

      "}" ->
        1197

      ">" ->
        25137
    end
  end
end
