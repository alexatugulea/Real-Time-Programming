defmodule Timer do
    use GenServer
    
    @impl true
    def init(_state) do
        {:ok, []}
    end
    
    def start_link(_arg) do
        GenServer.start(__MODULE__, :ok, name: __MODULE__)
    end
  
    def add(timeNow) do
        GenServer.cast(__MODULE__, {:compare, timeNow})
    end
  
    @impl true
    def handle_cast({:compare, timeNow}, state) do
        start = state;
        difference = start - timeNow;
  
        {:noreply, start}
    end

  end