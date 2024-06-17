defmodule Wrilya.Discord.Consumer do
  @moduledoc """
  The Discord Consumer module handles incoming events from a discord bot.
  This process (via the Nostrum.Consumer implementation) will poll a discord
  channel for events/messages and provide a hook for us to route those messages
  to a service.
  """

  # ----------------------------------------------------------------------------
  # Module Requires
  # ----------------------------------------------------------------------------
  require Logger

  # ----------------------------------------------------------------------------
  # Module Use
  # ----------------------------------------------------------------------------
  use Nostrum.Consumer

  # ----------------------------------------------------------------------------
  # Module Alias
  # ----------------------------------------------------------------------------
  alias Nostrum.Api

  # ----------------------------------------------------------------------------
  # Module Public APIs
  # ----------------------------------------------------------------------------

  @doc """
  Handled pulled events from discord.
  """
  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # Default implementation that was pulled from the Nostrum samples.  This should
    # be refactored when more time can be directed to Discord bot messaging, etc.
    case msg.content do
      "!sleep" ->
        Api.create_message(msg.channel_id, "Going to sleep...")
        # This won't stop other events from being handled.
        Process.sleep(3000)

      "!ping" ->
        Api.create_message(msg.channel_id, "pyongyang!")

      "!raise" ->
        # This won't crash the entire Consumer.
        raise "No problems here!"

      _ ->
        :ignore
    end
  end

  def handle_event({:INTERACTION_CREATE, interaction, ws_state}) do
    # Triggered via discord slash commands
    process_command(interaction.data.name, interaction, ws_state)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event), do: :noop

  # ----------------------------------------------------------------------------
  # Module Private Helpers
  # ----------------------------------------------------------------------------

  defp process_command("engage", interaction, _state) do
    [option] = interaction.data.options

    response = %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "aye-aye captain! Going to warp factor #{option.value}"
      }
    }

    Api.create_interaction_response(interaction, response)
  end

  defp process_command("proposals", interaction, _state) do
    # Fetch the proposals.  For now we are going to hard code
    # some values for POC reasons
    [option] = interaction.data.options

    proposals =
      Wrilya.Tally.fetch_proposals!(
        option.value,
        "eip155:1115511",
        # Governor contract
        ["0x43d571703bd54d06BfDf35EA62b7b7da66ed33D7"]
      )
    content =
      case proposals do
        [] ->
          """
          ----------------------------------------------
          No proposals with the state of #{option.value}
          """
        _ ->
          Enum.reduce(proposals, "", fn proposal, out ->
            out <>
              """
              ----------------------
              #{proposal.description |> String.trim_leading("# ")}
              """
          end)
      end

    response = %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: content
      }
    }

    Api.create_interaction_response(interaction, response)
  end

  defp process_command(cmd, interaction, _state) do
    Logger.error("[#{__MODULE__}.process_command/3] Unknown command type: #{inspect(cmd)}")

    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{content: "unknown command"}
    })
  end
end
