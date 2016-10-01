defmodule WurmRestClient.Mixfile do
  use Mix.Project

  def project do
    [app: :wurm_rest_client,
     name: "Wurm Rest Client",
     version: "0.1.0",
     elixir: "~> 1.3",
     source_url: "https://github.com/taufiqkh/wurm_rest_client",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript_config,
     docs: [
      main: "readme",
      extras: ["README.md"],
      output: "docs",
     ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9.2"},
      {:poison, "~> 2.2"},
      {:mock, "~> 0.1.1", only: :test},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.0", only: :dev},
    ]
  end

  defp escript_config do
    [ main_module: WurmRestClient.CLI ]
  end
end
