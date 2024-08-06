defmodule WrilyaWeb.AuthController do
  @doc """

  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger
  require Jason

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------
  use WrilyaWeb, :controller

  # ----------------------------------------------------------------------------
  # Module Plugs
  # ----------------------------------------------------------------------------
  plug Ueberauth, base_path: "/auth"
  plug :scrub_params, "user" when action in [:sign_in_user]

  # ----------------------------------------------------------------------------
  # Module Alias
  # ----------------------------------------------------------------------------
  alias Ueberauth.Strategy.Helpers

  # ----------------------------------------------------------------------------
  # Module API
  # ----------------------------------------------------------------------------
  @spec login(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def login(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn))
  end

  @spec logout(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def logout(conn, _params) do
    conn
    |> Account.Guardian.Plug.sign_out()
    |> clear_session()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: "/auth/login")
  end

  @spec redirect_login(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def redirect_login(conn, _params) do
    conn
    |> redirect(to: "/auth/login")
  end

  @spec provider(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def provider(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn))
  end

  @spec callback(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> put_status(401)
    |> redirect(to: "/auth/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Account.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> Account.Guardian.Plug.sign_in(user)
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(external: "http://localhost:8080")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/auth/login")
    end
  end
end
