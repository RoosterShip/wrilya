import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "app",
  enums: {
    HomeEnum: [
      "ICOIR",
      "VREL",
      "PRIME",
      "MILVEA",
      "SAREA",
      "GRAIK",
      "CHIVEN",
      "AIGEA"
    ],
    FieldEnum: [
      "ARMOR",
      "ENGINES",
      "LEADERSHIP",
      "NAVIGATION",
      "NEGOTIATION",
      "SHIPCRAFT",
      "SENSORS",
      "SHIELDS",
      "WEAPONS"
    ],
    AbilityEnum: [
      "STRENGTH",
      "PSYCHE",
      "TECHNIQUE",
      "INTELLIGENCE",
      "FOCUS",
      "ENDURANCE",
      "RELEXES"
    ]
  },
  tables: {
    // Signal 
    VoidsmenTable: "bool",
    ShipTable: "bool",
    OwnedByTable: "bytes32",
    HomeTable: "HomeEnum",
    NameTable: "string",
    PortraitTable: "string",
    TrainingTable: {
      schema: {
        entity: "bytes32",
        time: "uint256",
        field: "FieldEnum"
      },
      key: ["entity"],
      codegen: {
        dataStruct: false
      }
    },
    PersonaTable: {
      schema: {
        // Key
        entity: "bytes32",
        // Values
        xp: "uint32",
        competencies: "uint8[]",
        stats: "uint8[]",
      },
      key: ["entity"],
    },
    EntityCounterTable: {
      schema: {
        value: "uint256",
      },
      key: [],
    },
    Counter: {
      schema: {
        value: "uint32",
      },
      key: [],
    },
  },
});
