defmodule Connection do

  def start_link(link) do
    handle = spawn_link(fn -> get_msg() end)
    {:ok, _pid} = EventsourceEx.new(link, stream_to: handle)
  end

  def get_msg() do
      receive do
        msg -> GenServer.cast(Router, {:router, msg})
      end
      get_msg()
  end

 def child_spec(arg) do
   %{
     id: Connection,
     start: {Connection, :start_link, [arg]},
     #type: :worker,
     #restart: :permanent
   }
 end

end
