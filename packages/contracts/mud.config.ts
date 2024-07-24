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
  namespace: "wrilya",
  userTypes: {
    EncodedLengths: { filePath: "@latticexyz/store/src/EncodedLengths.sol", type: "bytes32" },
    ResourceId: { filePath: "@latticexyz/store/src/ResourceId.sol", type: "bytes32" },
  },

  // --------------------------------------------------------------------------
  // World Enumerations
  // --------------------------------------------------------------------------
  enums: {
    /**
     * Commands are operations that happen off chain but need some offchain
     * operations to trigger.  In this case we are Commanding the game server
     * to do something.
     * 
     * Example of this could be to say "Start an event" if a vote goes through. 
     */
    Command: [
      "UNKNOWN",                            // 0,
      "PAUSE",                              // 1,
      "RESUME",                             // 2,
    ],

    Notice: [
      "UNKNOWN",                            // 0,
    ],

    /**
     * Enumeration of the basic actor types in the game.
     */
    Actor: [
      "UNKNOWN",                            // 0
      "VOIDSMAN",                           // 1
      "SHIP",                               // 2
      "STATION",                            // 3
      "PLANET",                             // 4
      "SOLARSYSTEM",                        // 5
      "LOT"                                 // 6
    ],

    Knowledge: [
      "UNKNOWN",                            // 0
      "COMMAND",                            // 1
      "PILOT",                              // 2
      "WEAPONS",                            // 3
      "SHIELDS",                            // 4
      "SHIPCRAFT",                          // 5
      "SENSORS",                            // 6
      "MEDICAL",                            // 7
    ],

    Ability: [
      "UNKNOWN",                            // 0
      "FITNESS",                            // 1
      "PSYCHE",                             // 2
      "TECHNIQUE",                          // 3
      "INTELLIGENCE",                       // 4
      "FOCUS",                              // 5
      "ENDURANCE",                          // 6
      "REFLEX",                             // 7
    ],

    Auction: [
      "UNKNOWN",                            // 0
      "LIST",                               // 1
      "ENGLISH",                            // 2
      "DUTCH",                              // 3
      "PENNY",                              // 4
    ]

  },

  // --------------------------------------------------------------------------
  // World Tables
  // --------------------------------------------------------------------------

  tables: {

    //-------------------------------------------------------------------------
    // Global Game Configuration and Management Table
    //-------------------------------------------------------------------------

    /**
     * Game Config
     * 
     * Used to store on chain configuration data.
     */
    GameConfig: {
      key: [],
      schema: {
        /**
         * Is the game active at the moment.  If the result is false then any
         * transaction will be rejected by the system.
         */
        active: "bool",

        /**
         * Address of the governor contract.  The governor contract has access
         * to certain game functions that are meant to be executed via a DAO
         */
        governor: "address",

        /**
         * The game manager address.  An account which is operating the game.
         * 
         * For the most part the gm account will post results of matchs or 
         * other offchain simulated actions.  The GM does NOT have access to
         * modify tuning data or user state info.  It is basically an arbiter
         * of the game rules and validates the results of offchain actions
         */
        gm: "address",

        /**
         * Through the course of playing the game some operations will require
         * payment of the game tokens.  In such a case the this is the address
         * which will receive the payments.
         * 
         * The GM has the permission to set this address
         */
        payee: "address",

        /**
         * ERC-20 proxy contract.  Wrilya has a game token but this token is
         * stored in the MUD.dev contracts, but to better support other systems
         * that want to use a standard ERC-20 interface this proxy contract will
         * route the calls to MUD.  Special permission is granted to the interface
         * functions such as mint/transfer/burn in that they MUST come from the
         * currency proxy address.
         */
        currencyProxy: "address",

        /**
         * ERC-1155 proxy contract used to route requests to MUD for items.
         * Items are "fungable" in that there is no difference between any two
         * however we do not allow them to split
         */
        itemProxy: "address",

        /**
         * ERC-721 proxy contract for all entities in the game.  Entities can
         * be plots of land, voidsman, ships, stations, etc, etc.
         */
        entityProxy: "address",
      }
    },

    //-------------------------------------------------------------------------
    // Verified Operations
    //
    // There are times when the server needs to send down a verified operation
    // that the blockchain code will want to make sure came from a specific account.
    //
    // This is to ensure replay attacks don't happen, etc.
    VerifiedOps: {
      key: ["id"],
      schema: {
        id: "bytes16",
        processed: "bool",
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Banning
    //
    // List of banned players from the game.
    //
    // Temporary Ban:  Set by the Game Master. Is only temporary and will expire
    // Perminate Ban:  Set by the Goveranor and does not expire.

    BanTuning: {
      key: [],
      schema: {
        tempTime: "uint256"
      }
    },

    BanTemp: {
      key: ["account"],
      schema: {
        account: "address",
        expires: "uint256"
      }
    },

    BanPerm: {
      key: ["account"],
      schema: {
        account: "address",
        value: "bool"
      }
    },

    //-------------------------------------------------------------------------
    // Messaging
    //
    // Messaging falls into two types.  Commands and Notices.  You can think
    // of a Command more like something that MUST be processed by the offchain
    // services and a notice is more of a heads up that something happened.
    //
    // The difference between the two is commands are tracked and guarteed to be
    // processed by the system IN ORDER.  Notice are a best attempt and may or
    // maynot be processed at all.
    //-------------------------------------------------------------------------

    /**
     * Command Nonce Counter
     */
    CommandNonce: {
      key: [],
      schema: {
        value: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * Commands are requests to the offchain game to trigger some set of actions.
     * Each command request is saved on chain and is guaranteed to be processed.
     */
    Commands: {
      key: ["id"],
      schema: {
        id: "bytes32",
        cmd: "Command",
        data: "bytes",
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * Notice table which will be updated by notifications that something
     * happened on chain. Notifications are not fault tolerant in the case of
     * a system down event.
     */
    Notices: {
      type: "offchainTable",
      key: [],
      schema: {
        notice: "Notice",
        data: "bytes",
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Entity
    //
    // All things in the system is an entity. 
    //-------------------------------------------------------------------------
    EntityNonce: {
      key: [],
      schema: {
        value: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    EntityInfo: {
      key: ["entity"],
      schema: {
        entity: "bytes32",
        owner: "bytes32",
        actorType: "Actor",
        offchain: "bytes16"
      },
      codegen: {
        dataStruct: false
      }
    },

    EntityBalance: {
      key: ["owner"],
      schema: {
        owner: "bytes32",
        value: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Voidsman (VM for short)
    //-------------------------------------------------------------------------
    VMGeneralTuning: {
      key: [],
      schema: {
        // Minting based value
        mintFee: "uint256",

        // Level Tuning
        xpMax: "uint256",
        xpBase: "uint256",
        xpPower: "uint256"

      },
      codegen: {
        dataStruct: false
      }
    },

    VMSkillsTuning: {
      key: [],
      schema: {
        // Knowledge Based Values
        trainingFieldMaxValue: "uint8",
        trainingFieldsMaxTotal: "uint16",
        trainingCostBase: "uint256",
        trainingCostPower: "uint256",
        trainingTimeBase: "uint256",
        trainingTimePower: "uint256",

        // Ability Based Fields
        abilityFieldMaxValue: "uint8",
        abilityPointsBase: "uint256",
        abilityPointsPower: "uint256",
        abilityRespecMax: "uint16",
        abilityRespecCostBase: "uint256",
        abilityRespecCostPower: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    VMInfo: {
      key: ["entity"],
      schema: {
        entity: "bytes32",
        skills: "bytes32",
        xp: "uint256",
        rs: "uint16",
      },
      codegen: {
        dataStruct: false
      }
    },

    VMLearning: {
      key: ["entity"],
      schema: {
        // Key
        entity: "bytes32",

        // Values
        time: "uint256",
        field: "Knowledge"
      },
      codegen: {
        dataStruct: false
      }
    },

    VMLearnReq: {
      key: ["level", "field"],
      schema: {
        // key
        level: "uint8",
        field: "Knowledge",

        // Values
        xp: "uint256",
        skills: "bytes32",
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Currency Table
    //-------------------------------------------------------------------------
    CurrencyConfig: {
      key: [],
      schema: {
        totalSupply: "uint256",
        liquidity: "uint256",
        xchgActive: "bool"
      },
      codegen: {
        dataStruct: false
      }
    },

    CurrencyTuning: {
      key: [],
      schema: {
        maxSupply: "uint256",
        xchgFeeBuy: "uint256",
        xchgFeeSell: "uint256",
        xchgSegment: "uint256",
        xchgNonce: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    CurrencyXchgSegment: {
      key: ["index"],
      schema: {
        index: "uint256",
        balanceStart: "uint256",
        balanceEnd: "uint256",
        raise: "uint256",
        normalized: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Ledger Table
    //-------------------------------------------------------------------------
    LedgerTuning: {
      key: [],
      schema: {
        baseDebit: "uint256",
        maxDebit: "uint256",
        maxStake: "uint256",
        maxUnstake: "uint256",
        timeToUnstake: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    /**
     * The currency table defines how much in-game tokens you have.  Currently
     * I am keeping this in 3 fields:
     * 
     * - tokens:  The balance you ACTUALLY have
     * - credits: A balance that can be used for services but not traded, etc
     * - debit:   How much you own to the empire for services, etc.
     */
    LedgerInfo: {
      key: ["owner"],
      schema: {
        // Key
        owner: "bytes32",

        // Value
        tokens: "uint256",
        credits: "uint256",
        debit: "uint256",

        // Stacking Values
        staked: "uint256",
        unstaked: "uint256",
        uts: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    //-------------------------------------------------------------------------
    // Marketplace Tables
    //-------------------------------------------------------------------------
    MPConfig: {
      key: [],
      schema: {
        active: "bool"
      },
      codegen: {
        dataStruct: false
      }
    },

    MPTuning: {
      key: [],
      schema: {
        listFee: "uint256",
        listRake: "uint256",

        englishFee: "uint256",
        englishRake: "uint256",
        englishMinTime: "uint256",
        englishMaxTime: "uint256",

        dutchFee: "uint256",
        dutchRake: "uint256",
        dutchMinTime: "uint256",
        dutchMaxTime: "uint256",

        pennyFee: "uint256",
        pennyRake: "uint256",
        pennyMinTime: "uint256",
        pennyMaxTime: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    MPNonce: {
      key: [],
      schema: {
        value: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    MPInfo: {
      key: ["auctionId"],
      schema: {
        auctionId: "bytes32",
        entityId: "bytes32",
        seller: "bytes32",
        auctionType: "Auction",
      },
      codegen: {
        dataStruct: false
      }
    },

    MPListInfo: {
      key: ["auctionId"],
      schema: {
        auctionId: "bytes32",
        price: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    MPEnglishInfo: {
      key: ["auctionId"],
      schema: {
        auctionId: "bytes32",
        endsAt: "uint256",
        startingPrice: "uint256",
        bidder: "bytes32",
        currentPrice: "uint256",
      },
      codegen: {
        dataStruct: false
      }
    },

    MPDutchInfo: {
      key: ["auctionId"],
      schema: {
        auctionId: "bytes32",
        startsAt: "uint256",
        endsAt: "uint256",
        startingPrice: "uint256",
        discountRate: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },

    MPPennyInfo: {
      key: ["auctionId"],
      schema: {
        auctionId: "bytes32",
        endsAt: "uint256",
        bidder: "bytes32",
        currentPrice: "uint256",
        total: "uint256"
      },
      codegen: {
        dataStruct: false
      }
    },
  }
});
