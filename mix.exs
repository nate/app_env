defmodule AppEnv.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_env,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.19", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Nathan Sutton"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nate/app_env"}
    ]
  end
end
