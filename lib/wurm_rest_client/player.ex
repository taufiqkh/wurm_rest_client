defmodule WurmRestClient.Player do
  @moduledoc """
  Retrieves player-related information from the external API
  """

  @rest_url Application.get_env(:wurm_rest_client, :rest_url)

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

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({:ok, %{status_code: status, body: body}}) do
    IO.puts "Unknown status #{status}"
    {:unknown, Poison.Parser.parse!(body)}
  end

  def handle_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Wurm API: #{message}"
    System.halt(2)
  end
end