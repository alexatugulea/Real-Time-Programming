defmodule WorkerSupervisor2 do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(msg) do
    spec = {Worker2, {msg}}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def terminate_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def send_msg(msg) do
    GenServer.cast(Worker2, {:worker, msg})
  end
end
