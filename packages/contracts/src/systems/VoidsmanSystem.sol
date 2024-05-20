// SPDX-License-Identifier: GPL-3.0-or-later
//
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
pragma solidity >=0.8.24;

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------

import { System } from "@latticexyz/world/src/System.sol";
import { toBytes32, getFieldUint8, setFieldUint8 } from "../utils.sol";
import { Unauthorized, InvalidCaller, InvalidState, NotReady } from "../errors.sol";
import { HomeEnum, FieldEnum, AbilityEnum } from "../codegen/common.sol";
//import {
//  EntityCounterTable,
//  VoidsmenTable,
//  ShipTable,
//  OwnedByTable,
//  HomeTable,
//  NameTable,
//  PortraitTable,
//  TrainingTable,
//  PersonaTable  } from "../codegen/index.sol";

// ----------------------------------------------------------------------------
/// @title VoidsmanSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Voidsmen.
contract VoidsmanSystem is System {

  uint8 constant MAX_LEVEL = 10;

  /// Create a new Crew member and assign it to the caller.  This crew member
  /// will have all levels set to 0.
  //
  /// @param name of the new crew member
  /// @param portrait code from the client that this voidsman is using
  /// @param home Enum value for the crew member
  function voidsmanCreate(string calldata name, string calldata portrait, HomeEnum home) public {
    // // Verify the sender is an actual wallet.
    // //
    // // NOTE: 
    // // 
    // // Might want to remove this later if used for batching
    // if(isContract(_msgSender())) revert InvalidCaller();

    // // Build the Entity ID
    // uint256 entityValue = EntityCounterTable.get();
    // EntityCounterTable.set(entityValue + 1);
    // bytes32 entityId = toBytes32(entityValue);

    // // Setup state values for the new Voidsman
    // NameTable.set(entityId, name);
    // HomeTable.set(entityId, home);
    // PortraitTable.set(entityId, portrait);
    // VoidsmenTable.set(entityId, true);
    // PersonaTable.set(entityId, 0, new uint8[](9), new uint8[](7));
    
    // // Setup the Ownership
    // OwnedByTable.set(entityId, toBytes32(_msgSender()));
  }

  /// Delete a crew member from the caller (burn NFT).
  ///
  /// Note: I might change this to actually transfer crew member instead
  /// @param entityId to delete from chain
  function voidsmanDestroy(bytes32 entityId) public {
    // if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    // Persona.deleteRecord(entityId);
    // Crew.deleteRecord(entityId);
    // OwnedBy.deleteRecord(entityId);
  }

  /// Start the training process for a crew member.  You can only have
  /// one skill being trained at any given time.
  /// @param entityId to train
  /// @param subject to train
  function voidsmanUpdateTrain(bytes32 entityId, FieldEnum subject) public {
    // // Does the caller own the entity?
    // if (OwnedByTable.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    // // Can the entity be trained?
    // if (TrainingTable.getTime(entityId) != uint256(0)) revert InvalidState();

    // // Pull out the competency level, calculate the time needed to train the level and set it
    // uint8 level = PersonaTable.getItemCompetencies(entityId, uint256(subject));

    // if(level >= MAX_LEVEL) revert InvalidState();

    // uint256 time = levelTime(uint256(level) + 1) + block.timestamp;
    // TrainingTable.set(entityId, time, subject);
  }

  /// Stop training a skill.  All time invested into training skill is also lost
  /// @param entityId to stop training
  function voidsmanUpdateCancel(bytes32 entityId) public {
    // // Does the caller own the entity?
    // if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    // Training.deleteRecord(entityId);
  }

  /// Once a crew person has finished training they can be "certified" to the
  /// next level.
  /// @param entityId to level up
  function voidsmanUpdateCertify(bytes32 entityId) public {
    // // Does the caller own the entity?
    // if (OwnedByTable.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    // (uint256 time, FieldEnum subject) = TrainingTable.get(entityId);
    // // Check that they ARE training
    // if (time == uint256(0)) revert InvalidState();
    // // Check that they are DONE training
    // if (time > block.timestamp) revert NotReady();
    // uint8 level = PersonaTable.getItemCompetencies(entityId, uint256(subject));
    // if(level >= MAX_LEVEL) revert InvalidState();

    // // Update the state
    // PersonaTable.updateCompetencies(entityId, uint256(subject), level + 1);
    // TrainingTable.deleteRecord(entityId);
  }

  function voidsmanTrainingRequirements(
    FieldEnum filed,
    uint8 level,
    uint256 cost,
    uint256 xp,
    uint8[] calldata competencies,
    uint8[] calldata stats)
  public {
    // Admin Only Operation ....   
  }

  /// Based on our tuning data levels should increase at a speed
  /// @param level base for time
  function levelTime(uint256 level) public pure returns (uint256) {
    return 10 * (level ** 6);
  }
}