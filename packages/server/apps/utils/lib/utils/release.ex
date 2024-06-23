defmodule Utils.Release do
  @moduledoc """
  Provides an off the shelf implementation of some command DB commands
  that can be used as a macro.

  Please review the release management documentation
  """

  # ----------------------------------------------------------------------------
  # Module Using Definition
  # ----------------------------------------------------------------------------
  @spec __using__(any()) :: {:__block__, [], [{:def, [...], [...]}, ...]}
  defmacro __using__(app: app) do
    quote do
      def create do
        Application.load(unquote(app))

        for repo <- Application.fetch_env!(unquote(app), :ecto_repos) do
          repo_config =
            unquote(app)
            |> Application.get_env(repo)
            |> Keyword.put(:otp_app, unquote(app))
            |> Keyword.put(:repo, unquote(app))

          repo_config =
            if repo_config[:url] do
              "ecto://" <> url_data = repo_config[:url]
              [us, pass, host, _port, db] = Regex.split(~r{:|@|/}, url_data)

              Keyword.merge(
                [username: us, password: pass, hostname: host, database: db],
                repo_config
              )
            else
              repo_config
            end

          case Ecto.Adapters.Postgres.storage_up(repo_config) do
            :ok ->
              :ok

            {:error, :already_up} ->
              :ok

            {:error, error} ->
              raise("Could not create #{inspect(repo)} repo error: #{inspect(error)}")
          end
        end
      end

      def migrate do
        Application.load(unquote(app))

        for repo <- Application.fetch_env!(unquote(app), :ecto_repos) do
          {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
        end
      end
    end
  end
end
