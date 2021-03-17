defmodule Tictactoe.GameManager do
  use GenServer

  def greet(peer_a, peer_b) do
    GenServer.call(__MODULE__, {:greet, peer_a, peer_b})
  end

  def get(peer) do
    GenServer.call(__MODULE__, {:get, peer})
  end

  def update(peer, board) do
    GenServer.call(__MODULE__, {:update, peer, board})
  end

  def start_link(_params) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call({:greet, peer_a, peer_b}, _from, state) do
    new_state =
      state
      |> Map.put(peer_a, %{x: peer_a, o: peer_b, tab: Tictactoe.Juego.nuevo()})
      |> Map.put(peer_b, %{x: peer_a, o: peer_b, tab: Tictactoe.Juego.nuevo()})

    {:reply, :ok, new_state}
  end

  def handle_call({:get, peer}, _from, state) do
    data = Map.get(state, peer)

    {:reply, data, state}
  end

  def handle_call({:update, peer, board}, _from, state) do
    state = Map.get(state, peer)

    new_state =
      state
      |> Map.put(state[:x], %{state | tab: board})
      |> Map.put(state[:o], %{state | tab: board})

    {:reply, :ok, new_state}
  end
end
