defmodule WurmRestClient.Player do
  @moduledoc """
  Retrieves player-related information.
  """

  require Logger

  @rest_url Application.get_env(:wurm_rest_client, :rest_url)

  # Fetch a URL and handle the response
  defp _fetch(url) do
    url
    |> HTTPoison.get
    |> handle_response
  end

  @doc """
  Fetch a count of all players currently playing
  """
  def fetch_count(), do: _fetch(players_count_url)

  @doc """
  Fetch all players
  """
  def fetch(), do: _fetch(players_url)

  @doc """
  Fetch the details for a given player
  """
  def fetch(player), do: _fetch(player_url(player))

  @doc """
  Given a player, fetches that player's current bank balance.
  """
  def fetch_money(player), do: _fetch(player_money_url(player))

  @doc """
  The URL for retrieving all players
  """
  def players_url(), do: "#{@rest_url}/players"

  @doc """
  The URL for retrieving a player count
  """
  def players_count_url, do: "#{players_url}?filter=total"

  @doc """
  Given a player, returns the URL that corresponds to that player
  """
  def player_url(player) do
    "#{players_url}/#{player.name}"
  end

  @doc """
  Given a player, returns the URL that corresponds to the location of the money resource for that player
  """
  def player_money_url(player), do: "#{player_url(player)}/money"

  @doc """
  Given a response to a Player request, returns a tuple depending on the response. If the API call was successfully
  completed, will return a response in the following form and its body as parsed from JSON:
  ```
  { result_type, response_body}
  ```
  A call may be successfully completed even if the result of that call was not success, for example if the player was
  not found. If the call was unsuccessful, returns a tuple in the following form:
  { :error_connect, reason }
  Where reason is an atom representing the reason for the call failure.

  ## Example
    iex> handle_response({:ok, %{status_code: 200, body: "{\"balance\": 260 }})
    %{:ok, %{balance: 260}}
    iex> handle_response({:error, %HTTPoison.Error{reason: :timeout}})
    %{:error_connect, :timeout}
  """
  def handle_response({:ok, %{status_code: status, body: body}}) do
    result_type = case status do
      200 -> :ok
      404 -> :missing
      504 -> :error_gateway
      400 ->
        Logger.error "Bad request for player: #{inspect(body)}"
        :bad_request
      _ -> :unknown
    end
    {result_type, Poison.Parser.parse!(body)}
  end
  def handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.warn "Error fetching from Wurm API: #{reason}"
    {:error_connect, reason}
  end
end