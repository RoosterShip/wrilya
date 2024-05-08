import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  enums: {
    Race: [
      "Unknown",
      "Human",
      "Icoir",
      "Vrel",
      "Milvea",
      "Sarea",
      "Graik",
      "Chiven"
    ]
  },
  tables: {
    // Signal 
    Crew: "bool",
    Ship: "bool",
    OwnedBy: "bytes32",
    Persona: {
      schema: {
        // Key
        entity: "bytes32",
        // Persona Info
        race: "Race",
        // Future Info:
        // imageHash: "bytes32"
        // descriptionHash: "bytes32"
        // Skills
        armor: "uint8",
        engines: "uint8",
        leadership: "uint8",
        navigation: "uint8",
        negotiation: "uint8",
        repairs: "uint8",
        sensors: "uint8",
        shields: "uint8",
        weapons: "uint8",
        // Crew Member Name
        name: "string",
      },
      key: ["entity"],
    },
    EntityCounter: {
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
