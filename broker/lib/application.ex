defmodule ApplicationModule do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # {Task, fn -> KVServer.accept(4040) end}
      %{
        id: Register,
        start: {Register, :init, []}
      },
      %{
        id: KVServer,
        start: {KVServer, :accept, [4040]}
      }
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
