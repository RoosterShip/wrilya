defmodule Wrilya.Discord do
  @moduledoc """
  Manages uploading commands and other discord based operations needed for
  Wrilya to run.

  TODO: This module should be removed from Wrilya and put into a common
        module.
  """

  # ----------------------------------------------------------------------------
  # Module alias
  # ----------------------------------------------------------------------------
  alias Nostrum.Api, as: Discord

  # ----------------------------------------------------------------------------
  # Module Constants
  # ----------------------------------------------------------------------------
  @cmd_engage %{
    name: "engage",
    description: "Set your warp factor",
    options: [
      %{
        # ApplicationCommandType::STRING
        type: 3,
        name: "action",
        description: "whether to assign or remove the role",
        required: true,
        choices: [
          %{
            name: "high warp",
            value: "10"
          },
          %{
            name: "low warp",
            value: "1"
          }
        ]
      }
    ]
  }

  @cmd_open_proposals %{
    name: "proposals",
    description: "List of active proposals",
    options: [
      %{
        # ApplicationCommandType::STRING
        type: 3,
        name: "state",
        description: "List the proposals of a given state",
        required: true,
        choices: [
          %{
            name: "PENDING",
            value: "PENDING"
          },
          %{
            name: "ACTIVE",
            value: "ACTIVE"
          },
          %{
            name: "PASSED",
            value: "PASSED"
          },
          %{
            name: "DEFEATED",
            value: "DEFEATED"
          }
        ]
      }
    ]
  }

  # ----------------------------------------------------------------------------
  # Module APIs
  # ----------------------------------------------------------------------------

  @doc """
  Load all the commands to the registered discord channels
  """
  @spec load_commands() :: :ok
  def load_commands() do
    # TODO: Refactor this to use a database table to store the guild commands
    #       in.  Mostly because I don't want to have to rebuild / redeploy
    #       each time we want to setup a new discord channel, etc.
    #
    #       Also the default value given is for testing purposes and should be
    #       removed in the future
    Application.get_env(:wrilya, :discord_guilds, [1_230_273_099_979_554_918])
    |> Enum.each(fn guild_id -> load_commands(guild_id) end)
  end

  @doc """
  Load Wrilya Slash commands to a specific guild channel in discord
  """
  @spec load_commands(guild_id :: non_neg_integer()) :: :ok
  def load_commands(guild_id) do
    {:ok, _} = Discord.create_guild_application_command(guild_id, @cmd_engage)
    {:ok, _} = Discord.create_guild_application_command(guild_id, @cmd_open_proposals)

    :ok
  end

  @spec publish!(msg :: String.t()) :: :ok
  def publish!(msg) do
    :ok = Nostrum.Api.create_message!(1230273100508172370, msg)
    :ok
  end

  @spec publish(msg :: String.t()) :: {:error, term}| {:ok, Nostrum.Struct.Message.t()}
  def publish(msg) do
    Nostrum.Api.create_message(1230273100508172370, msg)
  end
end
