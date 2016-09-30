defmodule WurmRestClient.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch to the core module. The command line exists as an example and for manual
  exploration of the Wurm REST API.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Returns a `:help` if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, player: :string], aliases: [h: :help, p: :player])

    case parse do
      {[help: true], _, _} -> :help
      {[player: player], _operations, _} ->
        # only 'get_money' supported for now
        %{operation: :get_money, player: %{ name: player }}
      _ -> :help
    end
  end

  def usage(exit) do
    IO.puts """
    usage: wurm_rest_client --player <name> <operation>
    where operation is one of the following:
    - money Gets balance details for the given player
    """
    System.halt(exit)
  end

  def process(:help) do
    usage(0)
  end

  def process(%{operation: operation, player: player}) do
    case operation do
      :get_money -> WurmRestClient.Player.fetch_money(player)
      _ -> usage(1)
    end
  end
end