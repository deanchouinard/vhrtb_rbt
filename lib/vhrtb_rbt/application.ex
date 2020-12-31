defmodule VhrtbRbt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [Bme280Sensor, SendData
      # Starts a worker by calling: VhrtbRbt.Worker.start_link(arg)
      # {VhrtbRbt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VhrtbRbt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
