import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  enums: {
    Race: [
      "UNKNOWN",
      "HUMAN",
      "ICOIR",
      "VREL",
      "MILVEA",
      "SAREA",
      "GRAIK",
      "CHIVEN"
    ],
    Skill: [
      "ARMOR",
      "ENGINES",
      "LEADERSHIP",
      "NAVIGATION",
      "NEGOTIATION",
      "REPAIRS",
      "SENSORS",
      "SHIELDS",
      "WEAPONS"
    ]
  },
  tables: {
    // Signal 
    Crew: "bool",
    Ship: "bool",
    OwnedBy: "bytes32",
    Training: {
      schema: {
        entity: "bytes32",
        time: "uint256",
        skill: "Skill"
      },
      key: ["entity"],
      codegen: {
        dataStruct: false
      }
    },
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
        skills: "bytes32",
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
