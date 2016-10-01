defmodule WurmRestClient do
  @moduledoc """
  Parent module for the client for the Wurm REST API as implemented by [wurmrest](https://github.com/taufiqkh/wurmrest).
  This module provides common functions for retrieving from the API and transformation of the response into basic
  enumerated result types.
  """

  require Logger

    @doc """
    Given a response to a request, returns a tuple depending on the response. If the API call was successfully
    completed, will return a response in the following form and its body as parsed from JSON:
    ```
    { result_type, response_body}
    ```
    A call may be successfully completed even if the result of that call was not success, for example if the player was
    not found. If the call was unsuccessful, returns a tuple in the following form:
    { :error_connect, reason }
    Where reason is an atom representing the reason for the call failure.

    ## Example
      iex> handle_response("http://localhost:8080/players/Bob/money", {:ok, %{status_code: 200, body: "{\"balance\": 260 }})
      %{:ok, %{balance: 260}}
      iex> handle_response("http://localhost:8080/players/Anne/money", {:error, %HTTPoison.Error{reason: :timeout}})
      %{:error_connect, :timeout}
    """
    def handle_response(url, {:ok, %{status_code: status, body: body}}) do
      result_type = case status do
        200 -> :ok
        404 -> :missing
        504 -> :error_gateway
        400 ->
          Logger.error "Bad request for player at #{url}: #{inspect(body)}"
          :bad_request
        _ -> :unknown
      end
      {result_type, Poison.Parser.parse!(body)}
    end
    def handle_response(url, {:error, %HTTPoison.Error{reason: reason}}) do
      Logger.warn "Error fetching from Wurm API at #{url}: #{reason}"
      {:error_connect, reason}
    end

    @doc """
    Fetch a URL and return the response, transformed to a result type with body.
    """
    def fetch(url) do
      url
      |> HTTPoison.get
      |> _handle_response(url).()
    end

    # Partial to handle the response for a specific URL
    defp _handle_response(url), do: fn response -> handle_response(url, response) end
end
