defmodule Tictactoe.Session do
  defstruct [:x, :o, tablero: %Tictactoe.Juego{}, listo: false]
end
