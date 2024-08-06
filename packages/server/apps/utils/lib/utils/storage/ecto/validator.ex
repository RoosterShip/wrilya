defmodule Utils.Storage.Ecto.Validator do
  import Ecto.Changeset

  def address(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn field, value ->
      case Utils.address?(value) do
        true ->
          []

        false ->
          [{field, "not an address"}]
      end
    end)
  end

  def uuid(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn _, value ->
      case Ecto.UUID.cast(value) do
        {:ok, _info} -> []
        _e -> [{field, {"is not a valid uuid", [validation: :uuid]}}]
      end
    end)
  end
end
