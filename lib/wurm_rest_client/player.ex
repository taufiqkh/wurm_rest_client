defmodule WurmRestClient.Player do
  @moduledoc """
  Retrieves player-related information.
  """

  require Logger

  @rest_url Application.get_env(:wurm_rest_client, :rest_url)

  @doc """
  Fetch a count of all players currently playing
  """
  def fetch_count(), do: WurmRestClient.fetch(players_count_url)

  @doc """
  Fetch all players
  """
  def fetch(), do: WurmRestClient.fetch(players_url)

  @doc """
  Fetch the details for a given player
  """
  def fetch(player), do: WurmRestClient.fetch(player_url(player))

  @doc """
  Given a player, fetches that player's current bank balance.
  """
  def fetch_money(player), do: WurmRestClient.fetch(player_money_url(player))

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
end