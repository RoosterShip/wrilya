defmodule Wrilya.Chain.Constants do
  @moduledoc """
  A copy of constant "enum" values defined in the MUD.config file.
  Currently this list must be hand managed due to the code gen
  nature of the MUD.config.

  @TODO:  If we ever get the resources it would be awesome if this
          this file could be code generated as well.
  """
  defmacro __using__(_opts) do
    quote do
      # Entity Values
      @entity_enum_unknown 0
      @entity_enum_voidsman 1
      @entity_enum_ship 2
      @entity_enum_planet 3
      @entity_enum_system 4

      # Home System Values
      @home_enum_unknown 0
      @home_enum_icoir 1
      @home_enum_vrel 2
      @home_enum_prime 3
      @home_enum_milvea 4
      @home_enum_sarea 5
      @home_enum_graik 6
      @home_enum_chiven 7
      @home_enum_aigea 8
      @home_enum_names %{
        0 => "Unknown",
        1 => "Icoir",
        2 => "Vrel",
        3 => "Prime",
        4 => "Milvea",
        5 => "Sarea",
        6 => "Graik",
        7 => "Chiven",
        8 => "Aigea",
      }

      # Field Enum
      @field_enum_unknown 0
      @field_enum_armor 1
      @field_enum_engines 2
      @field_enum_leadership 3
      @field_enum_navigation 4
      @field_enum_negotiation 5
      @field_enum_shipcraft 6
      @field_enum_sensors 7
      @field_enum_shields 8
      @field_enum_weapons 9

      @field_enum_names %{
        0 => "Unknown",
        1 => "Armor",
        2 => "Engines",
        3 => "Leadership",
        4 => "Navigation",
        5 => "Negotiation",
        6 => "Shipcraft",
        7 => "Sensors",
        8 => "Shields",
        9 => "Weapons",
      }

      # Ability Enum
      @ability_enum_unknown 0
      @ability_enum_strength 1
      @ability_enum_psyche 2
      @ability_enum_technique 3
      @ability_enum_intelligence 4
      @ability_enum_focus 5
      @ability_enum_endurance 6
      @ability_enum_relexes 7

      @ability_enum_names %{
        0 => "Unknown",
        1 => "Strength",
        2 => "Psyche",
        3 => "Technique",
        4 => "Intelligence",
        5 => "Focus",
        6 => "Endurance",
        7 => "Reflexes",
      }

    end
  end
end
