defmodule Tictactoe.Matchmaker do
  @moduledoc """
  The matchmaker will hold the list of users waiting to be served a game.
  Once two sessions are entered in the matchmaker, the system will
  automatically yield these two sessions so that they can start playing.
  """

  use GenServer

  def new(session), do: GenServer.call(__MODULE__, {:new, session})
  def disconnect(session), do: GenServer.call(__MODULE__, {:disconnect, session})

  def start_link(_params) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call({:new, session}, _from, state) do
    case Map.to_list(state) do
      [{session_id, peer_session} | _] ->
        new_state = Map.delete(state, session_id)
        {:reply, {:pair, session, peer_session}, new_state}

      _ ->
        new_state = Map.put(state, session.user_id, session)
        {:reply, :waiting, new_state}
    end
  end

  def handle_call({:disconnect, session}, _from, state) do
    new_state = Map.delete(state, session.user_id)
    {:reply, :ok, new_state}
  end
end
