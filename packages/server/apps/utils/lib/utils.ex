defmodule Utils do
  @moduledoc """
  Documentation for `Utils`.
  """

  require Logger

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the debug logs

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_debug("Step 1")
  |> step_2()
  |> pipe_debug("Step 2")
  |> step_3()
  |> pipe_debug("Step 3")
  ```
  """
  @spec pipe_debug(any, String.t()) :: any
  def pipe_debug(obj, header) do
    Logger.debug("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the info logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_info("Step 1")
  |> step_2()
  |> pipe_info("Step 2")
  |> step_3()
  |> pipe_info("Step 3")
  ```
  """
  @spec pipe_info(any, String.t()) :: any
  def pipe_info(obj, header) do
    Logger.info("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the warning logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_warn("Step 1")
  |> step_2()
  |> pipe_warn("Step 2")
  |> step_3()
  |> pipe_warn("Step 3")
  ```
  """
  @spec pipe_warn(any, String.t()) :: any
  def pipe_warn(obj, header) do
    Logger.warning("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  @doc """
  When using the pipe operatator it is is sometime useful to add a log statement
  to track progress or just debug the state.  This command can be used to output
  information to the error logs.

  example:

  ```
  foo
  |> step_1()
  |> step_2()
  |> step_3()
  ```

  to debug steps

  ```
  foo
  |> step_1()
  |> pipe_error("Step 1")
  |> step_2()
  |> pipe_error("Step 2")
  |> step_3()
  |> pipe_error("Step 3")
  ```
  """
  @spec pipe_error(any, String.t()) :: any
  def pipe_error(obj, header) do
    Logger.error("#{header}: #{inspect(obj, pretty: true, no_structs: true, limit: :infinity)}")
    obj
  end

  # ----------------------------------------------------------------------------
  # Module Macros
  # ----------------------------------------------------------------------------

  @doc """
  Sometime it just gets annoying to have to case calls that we want to throw
  an exception and just let it fail.  This call cleans up the code in those
  cases.  It is JUST syntax sugar for a case statement.
  """
  @spec unwrap!(any()) :: {:case, [{:column, 7} | {:do, [...]} | {:end, [...]}, ...], [...]}
  defmacro unwrap!(call) do
    quote do
      case unquote(call) do
        {:ok, unwrapped_value} -> unwrapped_value
        _ -> raise "Unwrap failure"
      end
    end
  end
end
