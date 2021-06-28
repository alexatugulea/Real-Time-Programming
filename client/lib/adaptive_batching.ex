defmodule AdaptiveBatching do
  use GenServer

  @impl true
  def init(_state) do
      {:ok, []}
  end

  def start_link(_arg) do
      GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def insert(tweet) do
      GenServer.cast(__MODULE__, {:insert, tweet})
  end

  @impl true
  def handle_cast({:insert, tweet}, state) do
      tweets = state ++ [tweet];

      if Enum.count(tweets) >= 128 do
        GenServer.cast(__MODULE__, :add_tweets_in_database)
      # else
      #   timeNow = :os.system_time(:millisecond);
      #   Timer.add(timeNow)
      end

      {:noreply, tweets}
  end

  @impl true
  def handle_cast(:add_tweets_in_database, tweets) do
    # IO.inspect(tweets)
    # IO.inspect(Enum.count(tweets))

    # IO.puts("All this data should be uploaded in Mongo")
    spawn(fn ->
      Enum.each(tweets, fn tweet ->
        add_tweets_in_database(tweet)
      end)
    end)
    {:noreply, []}
  end

  def add_tweets_in_database(message) do
    # IO.inspect(Enum.count(message))
    # {:ok, mongo} = Mongo.start_link(url: "mongodb://localhost:27017/rtp")
    # Mongo.insert_one!(mongo, "tweets", %{name: "lala"})
  end
end
