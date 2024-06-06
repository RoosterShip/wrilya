// Copyright (C) 2024 Decentralized Consulting
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  // --------------------------------------------------------------------------
  // World Configuration
  // --------------------------------------------------------------------------
  namespace: "game",
  userTypes: {
    EncodedLengths: { filePath: "@latticexyz/store/src/EncodedLengths.sol", type: "bytes32" },
    ResourceId: { filePath: "@latticexyz/store/src/ResourceId.sol", type: "bytes32" },
  },

  // --------------------------------------------------------------------------
  // World Enumerations
  // --------------------------------------------------------------------------
  enums: {
    /**
     * Enumeration of all the system operations that can take place.  This is
     * used for notification off chain that a certain operation has happened
     * and allow for listeners to react accordinly.
     * 
     * Example:
     * 
     * If the event "GAME_PAUSE" triggers then the game clients might log people out 
     */
    OperationEnum: [
      "UNKNOWN",                              // 0,

      // Game Config Ops

      "GAME_PAUSE",                           // 1
      "GAME_UNPAUSE",                         // 2
      "GAME_SET_ADMIN",                       // 3
      "GAME_SET_GM",                          // 4
      "GAME_SET_CURRENCY_PROXY",              // 5
      "GAME_SET_ITEM_PROXY",                  // 6
      "GAME_SET_ENTITY_PROXY",                // 7
      "GAME_SET_VOIDSMAN_CREATE_COST",        // 8
      "GAME_SET_VOIDSMAN_UPGRADE_TIME_BASE",  // 9
      "GAME_SET_VOIDSMAN_UPGRADE_TIME_POWER", // 10
      "GAME_SET_VOIDSMAN_UPGRADE_COST_BASE",  // 11
      "GAME_SET_VOIDSMAN_UPGRADE_COST_POWER", // 12
      "GAME_SET_VOIDSMAN_MAX_STATS",          // 13
      "GAME_SET_VOIDSMAN_MAX_COMPETENCY",     // 14
      "GAME_SET_STD_MAX_DEBIT",               // 15
      "GAME_SET_COLLATERAL_DEBIT_RATIO",      // 16
      "GAME_SET_CURRENCY_UNSTAKE_TIME",       // 17

      // Currency Ops
      "CURRENCY_MINT",                        // 18
      "CURRENCY_STAKE",                       // 19
      "CURRENCY_RELEASE",                     // 20
      "CURRENCY_CLAIM",                       // 21
      "CURRENCY_PAYMENT",                     // 22


      // Entity Ops
      "ENTITY_CREATE",                        // 23
      "ENTITY_DESTROY",                       // 24
      "ENTITY_TRANSFER",                      // 25
      "ENTITY_UPDATE",                        // 26

      // Voidsman Ops
      "VOIDSMAN_TRAIN",                       // 27
      "VOIDSMAN_TRAIN_CANCEL",                // 28
      "VOIDSMAN_CERTIFY",                     // 29
      "VOIDSMAN_SET_TRAINING_REQUIREMENT",    // 30
    ],

    /**
     * Enumeration of the basic entity types in the game.
     */
    EntityEnum: [
      "UNKNOWN",                            // 0
      "VOIDSMAN",                           // 1
      "SHIP",                               // 2
      "STATION",                            // 3
      "PLANET",                             // 4
      "SOLARSYSTEM",                        // 5
    ],

    /**
     * Enumeration of the star systems people call home.
     */
    HomeEnum: [
      "UNKNOWN",                // 0
      "ICOIR",                  // 1
      "VREL",                   // 2
      "PRIME",                  // 3
      "MILVEA",                 // 4
      "SAREA",                  // 5
      "GRAIK",                  // 6
      "CHIVEN",                 // 7
      "AIGEA"                   // 8
    ],

    /**
     * Fields of study that a voidsman can train in.
     */
    FieldEnum: [
      "UNKNOWN",                // 0
      "ARMOR",                  // 1
      "ENGINES",                // 2
      "LEADERSHIP",             // 3
      "NAVIGATION",             // 4
      "NEGOTIATION",            // 5
      "SHIPCRAFT",              // 6
      "SENSORS",                // 7
      "SHIELDS",                // 8
      "WEAPONS"                 // 9
    ],

    /**
     * The basic ability scores that a voidsman has
     * based on their current level.  These can be
     * used as gates.
     * 
     * Example:
     * 
     * To research engines level 5 you need technique level 2
     * and Intelligence level 5, etc. 
     */
    AbilityEnum: [
      "UNKNOWN",                // 0
      "STRENGTH",               // 1
      "PSYCHE",                 // 2
      "TECHNIQUE",              // 3
      "INTELLIGENCE",           // 4
      "FOCUS",                  // 5
      "ENDURANCE",              // 6
      "RELEXES"                 // 7
    ],
  },

  // --------------------------------------------------------------------------
  // World Tables
  // --------------------------------------------------------------------------

  tables: {

    //-------------------------------------------------------------------------
    // Global Game Configuration and Management Table
    //-------------------------------------------------------------------------

    /**
     * Game Config Table
     * 
     * Used to store on chain configuration data.
     */
    GameConfigTable: {
      key: [],
      schema: {
        /**
         * Is the game active at the moment.  If the result is false then any
         * transaction will fail in the system.
         */
        active: "bool",

        /**
         * The administrator address for this game.  
         */
        admin: "address",

        /**
         * The game manager address.  This is the account which acts as a trusted
         * source for data such as game play results, issuing rewards, etc.
         * 
         * NOTE:  This is typically a game server doing operations that would
         *        be to expensive to handle onchain.
         */
        gm: "address",

        /**
         * ERC-20 proxy contract  used to route requests to MUD for operations
         * effecting the main game currency.
         */
        currencyProxy: "address",

        /**
         * ERC-1155 proxy contract used to route requests to MUD 
         */
        itemProxy: "address",

        /**
         * ERC-721 proxy contract used to route requests to MUD 
         */
        entityProxy: "address",

        /**
         * Tuning param for the Training time
         */
        voidsmanCreateCost: "uint256",
        voidsmanUpgradeTimeBase: "uint256",
        voidsmanUpgradeTimePower: "uint256",
        voidsmanUpgradeCostBase: "uint256",
        voidsmanUpgradeCostPower: "uint256",
        voidsmanMaxStats: "uint8",
        voidsmanMaxCompetency: "uint8",

        /**
         * Costs Values
         */
        stdMaxDebit: "uint256",
        collateralDebitRatio: "uint256",
        currencyUnstakeTime: "uint256",
      }
    },

    //-------------------------------------------------------------------------
    // Offchain Notification Table
    //-------------------------------------------------------------------------

    NotificationIdTable: {
      key: [],
      schema: {
        value: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },
    /**
     * Offchain table which will be updated by notifications that something
     * happened on chain.  The data field is expected to be encoded arguments
     * needed for the offchain system to parse.
     */
    NotificationTable: {
      type: "offchainTable",
      key: [],
      schema: {
        operation: "OperationEnum",
        nid: "bytes32",
        data: "bytes",
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Currency Table
    //-------------------------------------------------------------------------

    /**
     * The currency table defines how much in-game tokens you have.  Currently
     * I am keeping this in 3 fields:
     * 
     * - tokens:  The balance you ACTUALLY have
     * - credits: A balance that can be used for services but not traded, etc
     * - debit:   How much you own to the empire for services, etc.
     */
    CurrencyTable: {
      key: ["owner"],
      schema: {
        // Key
        owner: "bytes32",

        // Value
        tokens: "uint256",
        credits: "uint256",
        staked: "uint256",
        unstaked: "uint256",
        uts: "uint256",
        debit: "uint256"
      }
    },

    //-------------------------------------------------------------------------
    // Generic Entity Table
    //-------------------------------------------------------------------------

    /**
     * A counter for generating entity Ids.
     */
    EntityIdTable: {
      key: [],
      schema: {
        value: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    EntityOwnerTable: {
      key: ["entity"],
      schema: {
        entity: "bytes32",
        value: "bytes32"
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * The type of entity this is
     */
    EntityTypeTable: {
      key: ["entity"],
      schema: {
        entity: "bytes32",
        value: "EntityEnum"
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * To ensure that each entity name is unique this table keeps a record of
     * all hashed named values in use.  If you have a match it will not
     * create the name...
     */
    EntityNameRegistryTable: {
      key: ["nameHash"],
      schema: {
        nameHash: "bytes32",
        value: "bool"
      }
    },

    /**
     * When creating an entity that includes a description, we will keep that
     * as a hashed value on chain.  The full description will be stored offchain
     * but you can use this hash as a key to fetch it.
     */
    EntityDescriptionTable: {
      key: ["entity"],
      schema: {
        entity: "bytes32",
        value: "bytes32",
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Voidsman Tables
    //-------------------------------------------------------------------------

    /**
     * Some generic info about this voidsman
     */
    VoidsmanPersonaTable: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        home: "HomeEnum",
        name: "string",
        portrait: "string",
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * The competency values of a voidman for set of fields.
     */
    VoidsmanInfoTable: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        xp: "uint32",
        comps: "uint8[]",
        stats: "uint8[]"
      },
    },

    /**
     * When training a voidsman it will take time and effort
     */
    VoidsmanTrainingTable: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        time: "uint256",
        field: "FieldEnum"
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * 
     */
    VoidsmanRequirementsTable: {
      key: ["level", "field"],
      schema: {
        // key
        level: "uint8",
        field: "FieldEnum",

        // Values
        xp: "uint256",
        competencies: "uint8[]",
        stats: "uint8[]",
      }
    },

    //-------------------------------------------------------------------------
    // Marketplace Voidsman
    //-------------------------------------------------------------------------
    MarketplaceVoidsman: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        cost: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    MarketplaceJobsBoard: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        cost: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    }
  },
});
