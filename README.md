# WurmRestClient

Elixir client for the Wurm REST API, as implemented by [wurmrest](https://taufiqkh.github.io/wurmrest/). Full
documentation including an API reference may be found at
[https://taufiqkh.github.io/wurm_rest_client/](https://taufiqkh.github.io/wurm_rest_client/).


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `wurm_rest_client` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:wurm_rest_client, "~> 0.1.0"}]
    end
    ```

  2. Ensure `wurm_rest_client` is started before your application:

    ```elixir
    def application do
      [applications: [:wurm_rest_client]]
    end
    ```

