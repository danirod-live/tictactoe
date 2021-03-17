defmodule Tictactoe.Router do
  use Plug.Router

  plug(:match)

  # plug(Plug.Static, from: {:tictactoe, "priv/static"}, at: "/static")

  plug(:dispatch)

  get "/" do
    file = EEx.eval_file("priv/templates/index.html.eex")
    send_resp(conn, 200, file)
  end

  get "/static/styles.css" do
    file = EEx.eval_file("priv/static/styles.css")
    send_resp(conn, 200, file)
  end

  get "/static/main.js" do
    file = EEx.eval_file("priv/static/main.js")
    send_resp(conn, 200, file)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
