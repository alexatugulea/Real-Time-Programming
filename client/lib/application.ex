defmodule LAB1.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Broker,
        start: {Broker, :start_link, ['rtp-broker', 4040]},
      },
      %{
        id: Aggregator,
        start: {Aggregator, :start_link, [""]}
      },
      %{
        id: AdaptiveBatching,
        start: {AdaptiveBatching, :start_link, [""]}
      },
      %{
        id: Worker,
        start: {Worker, :start_link, [""]}
      },
      %{
        id: WorkerSupervisor,
        start: {WorkerSupervisor, :start_link, [""]}
      },
      %{
        id: Worker2,
        start: {Worker2, :start_link, [""]}
      },
      %{
        id: WorkerSupervisor2,
        start: {WorkerSupervisor2, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: Connection2,
        start: {Connection, :start_link, ["rtp-tweets-faf18x:4000/tweets/2"]}
      },
      %{
        id: Connection1,
        start: {Connection, :start_link, ["rtp-tweets-faf18x:4000/tweets/1"]}
      }

    ]

    opts = [strategy: :one_for_one, name: LAB1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
