defmodule Utils.Storage.StdRecord do
  @moduledoc """
  A set of macros to bring in some standard functions I want for a module.
  Since many records just need the same old same old when it comes to creating
  reading updating and deleting, we can save ourselfs a few keystrokes
  """

  # ----------------------------------------------------------------------------
  # Module Using Definnition
  # ----------------------------------------------------------------------------

  @spec __using__(any()) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      @doc false
      @spec changeset(
              {map(), map()}
              | %{
                  :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
                  optional(atom()) => any()
                },
              :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
            ) :: Ecto.Changeset.t()
      def changeset(inst, attrs) do
        inst
        |> cast(attrs, @new_keys)
        |> validate_required(@required_keys)
        |> do_validate()
      end

      @doc false
      @spec changeset_update(
              {map(), map()}
              | %{
                  :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
                  optional(atom()) => any()
                },
              :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
            ) :: Ecto.Changeset.t()
      def changeset_update(inst, attrs) do
        inst
        |> cast(attrs, @update_keys)
        |> do_validate()
      end

      @doc false
      @spec validate(
              :invalid
              | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
            ) :: {:error, Ecto.Changeset.t()} | {:ok, map()}
      def validate(attrs) do
        %__MODULE__{}
        |> cast(attrs, @update_keys)
        |> do_validate()
        |> apply_action(:validate)
      end

      @doc false
      @spec cast_to_list(map() | keyword()) :: keyword()
      def cast_to_list(attrs), do: Utils.filter_to_keyword(attrs, @update_keys)
    end
  end
end
