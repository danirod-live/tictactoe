import Mix.Config

config :tictactoe, Tictactoe.Handler,
  port: 3000,
  path: "/game",
  # don't accept connections if server already has this number of connections
  max_connections: 10000,
  # force to disconnect a connection if the duration passed. if :infinity is set, do nothing.
  max_connection_age: :infinity,
  # disconnect if no event comes on a connection during this duration
  idle_timeout: 120_000,
  # TCP SO_REUSEPORT flag
  reuse_port: false,
  show_debug_logs: false,
  transmission_limit: [
    # if 50 frames are sent on a connection
    capacity: 50,
    # in 2 seconds, disconnect it.
    duration: 2000
  ]
