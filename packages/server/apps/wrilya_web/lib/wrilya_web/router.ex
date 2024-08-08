defmodule WrilyaWeb.Router do
  @moduledoc """
  Exposed Endpoints and mapping to controllers to handle the requests.

  Check out Phoenix and Plug for more details if needed
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use WrilyaWeb, :router

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @auth_plug Account.auth_plug()

  # ----------------------------------------------------------------------------
  # Module Pipelines
  # ----------------------------------------------------------------------------

  # Standard Browser page services
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WrilyaWeb.Layouts, :root}

    plug :protect_from_forgery,
      allow_hosts: [
        "localhost",
        "localhost:8080",
        "localhost:4000",
        "wrilya.com",
        ".wrilya.com",
        "google.com",
        ".google.com",
        "discord.com",
        ".discord.com"
      ]

    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: ["http://localhost:8080"]
  end

  # Standard Auth plug. Basically defines what to do in cases of errors, etc.
  pipeline :auth do
    plug @auth_plug
  end

  pipeline :session do
    plug :fetch_session
  end

  # Pipeline that requires a user is logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  end

  # ----------------------------------------------------------------------------
  # Module Scopes
  # ----------------------------------------------------------------------------

  scope "/api", WrilyaWeb do
    pipe_through :api

    scope "/status" do
      get "/healthy", StatusController, :healthy
      get "/ready", StatusController, :ready
    end

    scope "/session" do
      pipe_through [:session, :auth, :ensure_auth]
      get "/initialize/:address", SessionController, :initialize

      scope "/voidsman" do
        get "/manifest", Session.VoidsmanController, :manifest
        post "/premint", Session.VoidsmanController, :premint
        options "/premint", Session.VoidsmanController, :premintOptions
      end
    end
  end

  scope "/auth", WrilyaWeb do
    pipe_through [:browser, :auth, :session]
    get "/", AuthController, :redirect_login

    get "/login", AuthController, :login
    get "/logout", AuthController, :logout

    get "/:provider", AuthController, :provider
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:wrilya_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WrilyaWeb.Telemetry
      # forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
