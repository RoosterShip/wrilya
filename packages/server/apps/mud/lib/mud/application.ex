defmodule MUD.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MUD.Worker.start_link(arg)
      MUD.Repo,
      {Phoenix.PubSub, name: MUD.PubSub},
      # EctoWatch doesn't seem to support prefixes yet which makes this a pain.
      # However I really like that I can use Ecto Query syntax now instead of
      # the way I was doing it before which is pretty cool.  I also posted a
      # question to the owners of the library to see if I get a response
      {EctoWatch,
        repo: MUD.Repo,
        pub_sub: MUD.PubSub,
        watchers: [
          {MUD.Data.GameNotification, :inserted},
          {MUD.Data.GameNotification, :updated},
          {MUD.Data.GameNotification, :deleted}
        ]},
       MUD.Notification
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MUD.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
