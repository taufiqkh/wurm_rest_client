defmodule WurmRestClient.Player do
  @moduledoc """
  Retrieves player-related information from the external API
  """

  require Logger

  @rest_url Application.get_env(:wurm_rest_client, :rest_url)

  @doc """
  Given a player, fetches that player's current bank balance.
  """
  def fetch_money(player) do
    player_money_url(player)
    |> HTTPoison.get
    |> handle_response
  end

  def player_url(player) do
    "#{@rest_url}/players/#{player.name}"
  end

  def player_money_url(player) do
    "#{player_url(player)}/money"
  end

  @doc """
  Given an :ok response to a Player request, returns an error code according to the response and its body as parsed from
  JSON.

  ## Example
    iex> handle_response({:ok, %{status_code: 200, body: "{\"balance\": 260 }})
    %{:ok, %{balance: 260}}
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