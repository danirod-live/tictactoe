defmodule Tictactoe.Handler do
  use Riverside, otp_app: :tictactoe

  @impl Riverside
  def init(session, _state) do
    IO.puts("Se conecta el user #{session.user_id}")

    case Tictactoe.Matchmaker.new(session) do
      :waiting ->
        IO.puts("Toca esperar")
        {:ok, session, %Tictactoe.Session{}}

      {:pair, peer_a, peer_b} ->
        IO.puts("Tenemos sesion")

        :ok = Tictactoe.GameManager.greet(peer_a.user_id, peer_b.user_id)

        deliver_user(peer_a.user_id, %{event: "ready", i_am: "X"})
        deliver_user(peer_b.user_id, %{event: "ready", i_am: "O"})

        {:ok, session, []}
    end
  end

  @impl Riverside
  def handle_message(%{"type" => "put", "x" => x, "y" => y}, session, state) do
    current_user = session.user_id

    %{x: user_x, o: user_o, tab: tablero} = Tictactoe.GameManager.get(current_user)
    who_am_i = if current_user == user_x, do: "X", else: "O"
    is_my_turn = tablero.proximo == who_am_i

    if is_my_turn do
      new_tablero = Tictactoe.Juego.avanzar(tablero, x, y)
      :ok = Tictactoe.GameManager.update(current_user, new_tablero)
      deliver_user(user_x, %{event: "sync", data: new_tablero})
      deliver_user(user_o, %{event: "sync", data: new_tablero})
    else
      deliver_me(%{event: "wrong"})
    end

    {:ok, session, state}
  end

  @impl Riverside
  def terminate(_reason, session, _state) do
    Tictactoe.Matchmaker.disconnect(session)
    :ok
  end
end
