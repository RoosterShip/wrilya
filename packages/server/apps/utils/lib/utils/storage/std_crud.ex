defmodule Utils.Storage.StdCRUD do
  @moduledoc """
  A set of macros to bring in some standard functions I want for a module.
  Since many records just need the same old same old when it comes to creating
  reading updating and deleting, we can save ourselfs a few keystrokes
  """

  # ----------------------------------------------------------------------------
  # Module Using Definnition
  # ----------------------------------------------------------------------------

  defmacro __using__(context: context, repo: repo) do
    quote do
      # ----------------------------------------------------------------------------
      # Module Imports
      # ----------------------------------------------------------------------------
      import Ecto.Query, warn: false

      # ----------------------------------------------------------------------------
      # Module Alias
      # ----------------------------------------------------------------------------
      alias unquote(context)
      alias unquote(repo)

      @doc """
      Create an empty change set for a chain that can be written back to the DB later.
      This can be used with Phoenix Forms, etc.
      """
      @spec empty() :: Ecto.Changeset.t()
      def empty(), do: %Record{} |> Record.changeset(%{})

      @doc """
      Pull a list of all the chains registered within the system.
      """
      @spec list() :: [%Record{}]
      def list(), do: Repo.all(Record)

      @doc """
      Get a paginated List of chains using the Flop framework.  Please
      read up on Flop for more details
      """
      @spec paginated(params :: map) ::
              {:ok, {[%Record{}], Flop.Meta.t()}} | {:error, Flop.Meta.t()}
      def paginated(params), do: Flop.validate_and_run(Record, params, for: Record)

      @doc """
      Get a chain by it's ID.  If the id doesn't exist then a nil value is returned
      """
      @spec get(id :: Ecto.UUID.t()) :: nil | %Record{}
      def get(id), do: Repo.get(Record, id)

      @doc """
      Get a chain by it's ID.  If the chain ID doesn't exist then an exception is raised
      """
      @spec get!(id :: Ecto.UUID.t()) :: %Record{}
      def get!(id), do: Repo.get!(Record, id)

      @doc """
      """
      @spec get?(id :: Ecto.UUID.t()) :: boolean
      def get?(id), do: Repo.exists?(id)

      # @doc """
      # """
      # @spec changeset(record :: %Record{}) :: %Ecto.Changeset{}
      # def changeset(record), do: Record.changeset(record, %{})

      # @doc """
      # Validate a block of arguments to see if everything will pass when submitted
      # to the ecto repo.
      # """
      # @spec validate(data :: map()) ::
      #         {:ok, %Ecto.Changeset{}} | {:error, %Ecto.Changeset{}}
      # def validate(data), do: Record.validate(data)

      @doc """
      Create a new record in the system.
      """
      @spec create(map() | Ecto.Changeset.t()) :: {:ok, %Record{}} | {:error, Ecto.Changeset.t()}
      def create(%Ecto.Changeset{} = chanageSet) do
        Repo.insert(chanageSet)
      end

      def create(attrs) when is_map(attrs) do
        %Record{}
        |> Record.changeset(attrs)
        |> create()
      end

      @doc """
      Create a new record in the system. This will throw an exception if error is found
      """
      @spec create!(map() | Ecto.Changeset.t()) :: %Record{}
      def create!(%Ecto.Changeset{} = chanageSet) do
        Repo.insert!(chanageSet)
      end

      def create!(attrs) when is_map(attrs) do
        %Record{}
        |> Record.changeset(attrs)
        |> create!()
      end

      @doc """
      Update the record of an chain.  You can change any field except for
      the ID field.

      ```
      %{
        type: atom
        title: String.t()
        network_id: atom
        active: boolean()
        meta: map()
      }
      ```

      """
      @spec update_for(rec :: Ecto.UUID.t() | %Record{}, attrs :: map) ::
              {:ok, %Record{}} | {:error, any()}
      def update_for(rec, attrs) when is_struct(rec, Record) do
        Record.changeset_update(rec, attrs)
        |> Repo.update()
      end

      def update_for(id, attrs) when is_bitstring(id) do
        case Record.validate(attrs) do
          {:ok, _} ->
            time = NaiveDateTime.utc_now()
            opts = Record.cast_to_list(attrs)

            from(t in Record, select: t, where: t.id == ^id, update: [set: [updated_at: ^time]])
            |> update(set: ^opts)
            |> Repo.update_all([])
            |> case do
              {_val, [record]} ->
                {:ok, record}

              {_val, _res} ->
                {:ok, nil}
            end

          e ->
            e
        end
      end

      @doc """
      Delete any application from the system.
      """
      @spec delete_for(rec :: Ecto.UUID.t() | %Record{}) ::
              {:ok, %Record{}} | {:error, Ecto.Changeset.t()}
      def delete_for(rec) when is_struct(rec, Record), do: Repo.delete(rec)

      def delete_for(id) when is_bitstring(id) do
        {_val, record} =
          from(t in Record, select: t, where: t.id == ^id)
          |> Repo.delete_all()

        case record do
          [record] ->
            {:ok, record}

          _ ->
            {:ok, nil}
        end
      end
    end
  end
end
