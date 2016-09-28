defmodule WurmRestClient.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch to the core module. The command line exists as an example and for manual
  exploration of the Wurm REST API.
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Returns a `:help` if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [player], _} -> %{ :player => %{ :name => player }}
      _ -> :help
    end
  end
end