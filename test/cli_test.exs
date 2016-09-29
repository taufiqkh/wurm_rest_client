defmodule CLITest do
  @moduledoc """
  Tests for the command line interface
  """

  use ExUnit.Case
  doctest WurmRestClient
  import WurmRestClient.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "player returned by option parsing with --player option" do
    assert %{operation: :get, player: %{name: "test"}} == parse_args(["-p", "test"])
    assert %{operation: :get, player: %{name: "test2"}} == parse_args(["--player", "test2"])
  end
end