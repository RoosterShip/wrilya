defmodule Wrilya.Chain.Notification.EntityCreate do
  use Wrilya.Chain.Constants
  use Wrilya.Chain.Notification.Operations
  defmacro __using__(_opts) do
    quote do
      def handle(unquote(@entity_create), nid, "0x"<>data) do
        [{_owner_id, entity_id, type}] =
          ABI.decode("(bytes32,bytes32,uint16)", data |> Base.decode16!(case: :lower))
        case type do
          unquote(@entity_enum_unknown) ->
            Logger.debug("Unknown Entity Created... not good")
            Logger.error("[Wrilya.Chain.Notification.EntityCreate] Unknown not supported")
          unquote(@entity_enum_voidsman) ->
            Logger.debug("[Wrilya.Chain.Notification.EntityCreate] Voidsman created")
            {:ok, voidsman} = Wrilya.Chain.Cache.voidsman(entity_id)
            Wrilya.Discord.publish("""
            ## ALERT NEW RECURIT:
            #{voidsman.name} from the home planet of #{voidsman.home} as registered as a Voidsman!
            """)
          unquote(@entity_enum_ship) ->
            Logger.error("[Wrilya.Chain.Notification.EntityCreate] Ship Unimplemented")
          unquote(@entity_enum_planet) ->
            Logger.error("[Wrilya.Chain.Notification.EntityCreate] Planet Unimplemented")
          unquote(@entity_enum_system) ->
            Logger.error("[Wrilya.Chain.Notification.EntityCreate] Solar System Unimplemented")
          _ ->
            Logger.error("[Wrilya.Chain.Notification.EntityCreate] Unsupported Entity Type")
        end
        :ok
      end
    end
  end
end
