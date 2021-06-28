defmodule Worker2 do
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
      json_parse(msg)
    end
  end

  def json_parse(msg) do
      msg_data = Jason.decode!(msg.data)
      calculate_engagement_ratio(msg_data["message"]["tweet"])
  end

  def calculate_engagement_ratio(tweet) do
    favourites_count = tweet["user"]["favourites_count"];
    retweet_count = tweet["retweet_count"];
    followers_count = tweet["user"]["followers_count"];

    tweetId = tweet["id"];

    if is_number(followers_count) and followers_count > 0  and tweetId do
      engagment_ratio = (favourites_count + retweet_count)/followers_count;
      Aggregator.add_engagement_ratio(engagment_ratio, tweetId)
    end

  end

   def get_child(pid) do
     GenServer.cast(pid, :get)
   end
end
