defmodule Account.Guardian do
  @moduledoc """
  Module for managing Guardian tokens.  This is used to issue and validate that
  a session can be used.

  The what auth is setup is we first verify the use via a 3rd party service
  like google, facebook, etc, and then issue a token via guardian if auth is
  successful

  NOTE:  This is pretty much a copy/paste job from the Guardian integration
  examples that can be found at their hex documentation
  """

  # ----------------------------------------------------------------------------
  # Module Uses
  # ----------------------------------------------------------------------------

  use Guardian, otp_app: :account

  # ----------------------------------------------------------------------------
  # Module Public API
  # ----------------------------------------------------------------------------

  @doc false
  @spec subject_for_token(
          atom() | %{:id => any(), optional(any()) => any()},
          any()
        ) ::
          {:ok, any()}
  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  @doc false
  # @spec resource_from_claims(map()) ::
  #        {:error, :resource_not_found}
  #        | {:ok,
  #           %Storage.User.Record{
  #             __meta__: any(),
  #             active: any(),
  #             auth_id: any(),
  #             auth_type: any(),
  #             email: any(),
  #             id: any(),
  #             inserted_at: any(),
  #             meta: any(),
  #             type: any(),
  #             updated_at: any()
  #           }}
  def resource_from_claims(%{"sub" => id}) do
    user = Account.Storage.user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  @doc false
  @spec after_encode_and_sign(
          resource :: any(),
          claims :: Guardian.Token.claims(),
          token :: Guardian.Token.token(),
          options :: Guardian.options()
        ) :: {:ok, Guardian.Token.token()} | {:error, atom()}
  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  @doc false
  @spec on_verify(
          claims :: Guardian.Token.claims(),
          token :: Guardian.Token.token(),
          options :: Guardian.options()
        ) :: {:ok, Guardian.Token.claims()} | {:error, any()}
  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  @doc false
  @callback on_refresh(
              old_token_and_claims :: {Guardian.Token.token(), Guardian.Token.claims()},
              new_token_and_claims :: {Guardian.Token.token(), Guardian.Token.claims()},
              options :: Guardian.options()
            ) ::
              {:ok, {Guardian.Token.token(), Guardian.Token.claims()},
               {Guardian.Token.token(), Guardian.Token.claims()}}
              | {:error, any()}
  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  @doc false
  @callback on_revoke(
              claims :: Guardian.Token.claims(),
              token :: Guardian.Token.token(),
              options :: Guardian.options()
            ) :: {:ok, Guardian.Token.claims()} | {:error, any()}
  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
