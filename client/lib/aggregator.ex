defmodule Aggregator do
    use GenServer

    def start_link(message) do
        GenServer.start(__MODULE__, message, name: __MODULE__)
    end

    def init(_state) do
        {:ok, %{tweets: %{}}}
    end

    def add_engagement_ratio(score, tweetId) do
        GenServer.cast(__MODULE__, {:engagement, {score, tweetId}})
    end

    def add_sentiment_score(score, tweetId) do
        GenServer.cast(__MODULE__, {:sentiment, {score, tweetId}})
    end

    def handle_cast({:engagement, {score, tweetId}}, state) do
        tweets = put_in_map("engagement", score, tweetId, state)
        {:noreply, %{tweets: tweets}}
    end

    def handle_cast({:sentiment, {score, tweetId}}, state) do
        tweets = put_in_map("sentiment", score, tweetId, state)
        {:noreply, %{tweets: tweets}}
    end

    def put_in_map(dataType, value, id, state) do
        tweets = state.tweets;
        doesTweetExists = Map.has_key?(tweets, id);

        if doesTweetExists do
            singleTweet = Map.get(tweets, id)
            singleTweet = Map.put(singleTweet, dataType, value)
            singleTweet = Map.put(singleTweet, "id", id)
            tweets =  Map.update!(tweets, id, fn _ -> singleTweet end)
            finalTweet = Map.get(tweets, id)
            AdaptiveBatching.insert(finalTweet)
            tweets = Map.delete(tweets, id)
        else
            tweets = Map.put(tweets, id, %{});
            singleTweet = Map.get(tweets, id)
            singleTweet = Map.put(singleTweet, dataType, value)
            tweets =  Map.update!(tweets, id, fn _ -> singleTweet end)
        end
    end
end
