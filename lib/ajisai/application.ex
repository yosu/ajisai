defmodule Ajisai.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AjisaiWeb.Telemetry,
      Ajisai.Repo,
      {DNSCluster, query: Application.get_env(:ajisai, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ajisai.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ajisai.Finch},
      # Start a worker by calling: Ajisai.Worker.start_link(arg)
      # {Ajisai.Worker, arg},
      # Start to serve requests, typically the last entry
      AjisaiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ajisai.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AjisaiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
