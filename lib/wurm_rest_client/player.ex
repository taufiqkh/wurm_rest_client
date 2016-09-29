defmodule WurmRestClient.Player do
  @moduledoc """
  Retrieves player-related information from the external API
  """

  def fetch_money(player) do
    player_money_url(player)
    |> HTTPoison.get
    |> handle_response
  end

  def player_url(player) do
    "http://localhost:8080/players/#{player.name}"
  end

  def player_money_url(player) do
    "#{player_url(player)}/money"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end
end