defmodule Account.Utils do
  @moduledoc """

  """

  @doc """
  Filters a Map or Keyword into a keyword list
  """
  @spec filter_to_keyword(map() | keyword(), [term()]) ::
          Keyword.t()
  def filter_to_keyword(attrs, filter_keys) do
    Enum.reduce(attrs, [], fn {key, value}, acc ->
      if Enum.member?(filter_keys, key) do
        Keyword.put(acc, key, value)
      else
        acc
      end
    end)
  end

  @doc """
  Filters a Map or Keyword into a Map
  """
  @spec filter_to_map(map() | keyword(), [term()]) ::
          Keyword.t()
  def filter_to_map(attrs, filter_keys) do
    Enum.reduce(attrs, %{}, fn {key, value}, acc ->
      if Enum.member?(filter_keys, key) do
        Map.put(acc, key, value)
      else
        acc
      end
    end)
  end
end
