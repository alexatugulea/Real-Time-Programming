defmodule Worker do
  use GenServer, restart: :transient

  def start_link(msg) do
    GenServer.start(__MODULE__, msg, name: __MODULE__)
  end

  @impl true
  def init(msg) do
    {:ok, msg}
  end

  @impl true
  def handle_cast({:worker, msg}, _states) do
    msg_operations(msg)
    {:noreply, %{}}
  end

  def msg_operations(msg) do
    if msg.data =~ "panic" do
      # IO.inspect(%{"Panic message:" => msg})
      Process.exit(self(), :kill)
    else
      data = json_parse(msg)
    end
  end

  def json_parse(msg) do
      msg_data = Jason.decode!(msg.data)
      calculate_sentiments(msg_data["message"]["tweet"])
      Broker.send_packet("tweets", msg_data["message"]["tweet"]["text"])
      Broker.send_packet("users", msg_data["message"]["tweet"]["user"])
  end

  def calculate_sentiments(data) do
    user_words_array = data["text"]
                       |> String.split(" ", trim: true)

    scores_array = Enum.map(user_words_array, fn word -> EmotionValues.get_value(word) end)
    final_score = Enum.sum(scores_array)

    tweetId = data["id"]

    if tweetId do
      Aggregator.add_sentiment_score(final_score, tweetId)
    end
  end

   def get_child(pid) do
     GenServer.cast(pid, :get)
   end

end
