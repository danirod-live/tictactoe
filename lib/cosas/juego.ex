defmodule Tictactoe.Juego do
  @p1 "X"
  @p2 "O"
  defstruct [:ganador, proximo: @p1, tablero: [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]]

  defp siguiente(@p1), do: @p2
  defp siguiente(@p2), do: @p1

  defp colocar(tablero, x, y, new) do
    nueva_fila = Enum.at(tablero, y - 1) |> List.replace_at(x - 1, new)
    tablero |> List.replace_at(y - 1, nueva_fila)
  end

  defp celda(tablero, x, y), do: Enum.at(tablero, y - 1) |> Enum.at(x - 1)

  def nuevo, do: %Tictactoe.Juego{}

  defp ganadora_horizontal?(tablero),
    do:
      Enum.any?(tablero, fn
        [@p1, @p1, @p1] -> true
        [@p2, @p2, @p2] -> true
        _ -> false
      end)

  defp ganadora_vertical?(tablero, x),
    do:
      celda(tablero, x, 1) != nil && celda(tablero, x, 1) == celda(tablero, x, 2) &&
        celda(tablero, x, 1) == celda(tablero, x, 3)

  defp ganadora_vertical?(tablero),
    do:
      ganadora_vertical?(tablero, 1) || ganadora_vertical?(tablero, 2) ||
        ganadora_vertical?(tablero, 3)

  defp ganadora_diagonal?([[@p1, _, _], [_, @p1, _], [_, _, @p1]]), do: true
  defp ganadora_diagonal?([[_, _, @p1], [_, @p1, _], [@p1, _, _]]), do: true
  defp ganadora_diagonal?([[@p2, _, _], [_, @p2, _], [_, _, @p2]]), do: true
  defp ganadora_diagonal?([[_, _, @p2], [_, @p2, _], [@p2, _, _]]), do: true
  defp ganadora_diagonal?(_), do: false

  defp ganadora?(tablero),
    do:
      ganadora_horizontal?(tablero) || ganadora_vertical?(tablero) || ganadora_diagonal?(tablero)

  def avanzar(%{ganador: g} = state, _, _) when g != nil, do: state

  def avanzar(%{proximo: p, tablero: t} = state, x, y) do
    if celda(t, x, y) == nil do
      new_t = colocar(t, x, y, p)
      new_s = %{state | proximo: siguiente(p), tablero: new_t}
      if ganadora?(new_t), do: %{new_s | ganador: p}, else: new_s
    else
      state
    end
  end
end
