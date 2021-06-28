defmodule Router do
  use GenServer

  def start_link(msg) do
    GenServer.start_link(__MODULE__, msg, name: __MODULE__)
  end

  @impl true
  def init(msg) do
    {:ok, msg}
  end

  @impl true
  def handle_cast({:router, msg}, _states) do
    WorkerSupervisor.start_worker(msg)
    WorkerSupervisor.send_msg(msg)

    WorkerSupervisor2.start_worker(msg)
    WorkerSupervisor2.send_msg(msg)
    
    {:noreply, %{}}
 end

 def child_spec(arg) do
  %{
    id: __MODULE__,
    start: {__MODULE__, :start_link, [arg]},
    type: :worker,
    restart: :permanent
  }
end

end
