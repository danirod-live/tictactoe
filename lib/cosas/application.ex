defmodule Tictactoe.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Riverside, [handler: Tictactoe.Handler, router: Tictactoe.Router]},
      {Tictactoe.Matchmaker, []},
      {Tictactoe.GameManager, []}
    ]

    opts = [strategy: :one_for_one, name: Tictactoe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
