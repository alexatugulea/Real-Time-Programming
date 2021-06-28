defmodule Broker do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, active: false])
    IO.puts("Connecting the client to the BROKER")

    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def send_packet(topic, body) do
    encoded = Poison.encode!(%{topic: topic, body: body})
    GenServer.cast(__MODULE__, {:send_packet, encoded})
  end

  def handle_cast({:send_packet, data}, state) do
    :gen_tcp.send(state.socket, data)
    {:noreply, state}
  end
end
