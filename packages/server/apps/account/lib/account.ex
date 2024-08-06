defmodule Account do
  @moduledoc """
  Account keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @token_check_ttl 10_000

  # ----------------------------------------------------------------------------
  # Module Modules
  # ----------------------------------------------------------------------------

  @doc """
  When a websocket processes is started we will want to verify that the connection
  token is still good.  Otherwise you can login with the guardian token and then
  that token would never be validated again.  This callback should be made within
  the `mount` callback of the live view

  ## Example:

  ```
  defmodule ExampleWeb.Live do
    require Account
    use ExampleWeb, :live_view

    def mount(params, session, socket) do
      socket = Account.init_token_loop(socket, session)
      {:ok, socket}
    end

    ...
  end
  ```
  """
  @spec init_token_loop(any(), any(), any()) :: {:__block__, [], [...]}
  defmacro init_token_loop(socket, session, ttl \\ @token_check_ttl) do
    quote do
      :ok = Process.send(self(), :token_check, [])

      unquote(socket)
      |> assign(
        token: Map.fetch!(unquote(session), "guardian_default_token"),
        user: Map.fetch!(unquote(session), "current_user"),
        ttl: unquote(ttl)
      )
    end
  end

  @doc """
  When handling the `:token_check` this function will validate if the
  given token is still good or not.  Integration should be pretty
  simple and can be copy/pasted into your LiveView controller like so:

  ## Example:

  ```
  defmodule ExampleWeb.Live do
    require Account
    use ExampleWeb, :live_view

    ...

    def handle_info(:token_check, socket), do: Account.validate_token_loop(socket)

    ...
  end
  ```
  """
  @spec validate_token_loop(any()) ::
          {:if,
           [
             {:column, 7}
             | {:context, Account}
             | {:do, [...]}
             | {:end, [...]}
             | {:imports, [...]},
             ...
           ], [[{any(), any()}, ...] | {:connected?, [...], [...]}, ...]}
  defmacro validate_token_loop(socket) do
    quote do
      if connected?(unquote(socket)) do
        case Account.Guardian.decode_and_verify(
               Map.fetch!(unquote(socket), :assigns) |> Map.fetch!(:token),
               %{
                 "typ" => "access"
               }
             ) do
          {:ok, _info} ->
            Process.send_after(
              self(),
              :token_check,
              Map.fetch!(unquote(socket), :assigns) |> Map.fetch!(:ttl)
            )

            {:noreply, unquote(socket)}

          {:error, _} ->
            {:noreply, push_redirect(unquote(socket), to: "/auth/login")}
        end
      else
        {:noreply, push_redirect(unquote(socket), to: "/auth/login")}
      end
    end
  end

  # ----------------------------------------------------------------------------
  # Module Functions
  # ----------------------------------------------------------------------------

  @doc """
  Execute a series of storage operations to seed the database with any required
  information.
  """
  @spec seed!() :: :ok
  def seed!(), do: Account.Seed.run()

  @doc """
  Return the module name of the plug to use for auth
  """
  @spec auth_plug() :: Account.Guardian.Pipeline
  def auth_plug(), do: Account.Guardian.Pipeline

  @doc """
  """
  @spec assigned_account(map()) :: any()
  def assigned_account(socket),
    do: Map.fetch!(socket, :assigns) |> Map.fetch!(:user)

  defp userTypeByProvider(:google), do: :admin
  defp userTypeByProvider(:discord), do: :app

  @doc """
  """
  # @spec find_or_create(map) :: {:ok, %Storage.User.Record{}} | {:error, term()}
  def find_or_create(%{provider: provider, uid: uid, info: info}) do
    type = userTypeByProvider(provider)

    case Account.Storage.user(uid, provider, type) do
      nil ->
        # In this case we have a valid user but we don't have a record
        Account.Storage.user_new(%{
          type: type,
          auth_id: uid,
          auth_type: provider,
          email: Map.fetch!(info, :email),
          avatar: get_avatar(info),
          meta: %{}
        })

      user ->
        avatar = get_avatar(info)
        # Check if our avatar link is up to date
        if user.avatar != avatar do
          Account.Storage.user_update(user, %{avatar: avatar})
        else
          {:ok, user}
        end
    end
  end

  def find_or_create(auth) do
    Logger.info(
      """
      ** UNKNOWN AUTH
      #{inspect(auth)}
      """,
      pretty: true,
      structs: false
    )

    {:error, :unsupported}
  end

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------

  defp get_avatar(%{image: avatar}), do: avatar
  defp get_avatar(_), do: ""
end
