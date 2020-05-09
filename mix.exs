defmodule Tinycluster.MixProject do
  use Mix.Project

  def project do
    [
      app: :tinycluster,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Tinycluster.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
