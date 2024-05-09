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
import { EntityCounter, Crew, Persona, OwnedBy, Training } from "../codegen/index.sol";
import { toBytes32, getFieldUint8, setFieldUint8 } from "../utils.sol";
import { Unauthorized, InvalidState, NotReady } from "../errors.sol";
import { Race, Skill } from "../codegen/common.sol";

// ----------------------------------------------------------------------------
/// @title GameSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Crew.
contract GameSystem is System {
  // --------------------------------------------------------------------------
  // CREW Interfaces
  // --------------------------------------------------------------------------

  /// Create a new Crew member and assign it to the caller.  This crew member
  /// will have all levels set to 0.
  //
  /// @param name of the new crew member
  /// @param race Enum value for the crew member
  function recruitCrew(string calldata name, Race race) public {
    bytes32 owner = toBytes32(_msgSender());
    uint256 entityValue = EntityCounter.get();
    EntityCounter.set(entityValue + 1);
    bytes32 entityId = toBytes32(entityValue);
    OwnedBy.set(entityId, owner);
    Crew.set(entityId, true);
    Persona.set(entityId, race, bytes32(0), name);
  }

  /// Delete a crew member from the caller (burn NFT).
  ///
  /// Note: I might change this to actually transfer crew member instead
  /// @param entityId to delete from chain
  function dismissCrew(bytes32 entityId) public {
    if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();

    Persona.deleteRecord(entityId);
    Crew.deleteRecord(entityId);
    OwnedBy.deleteRecord(entityId);
  }

  /// Start the training process for a crew member.  You can only have
  /// one skill being trained at any given time.
  /// @param entityId to train
  /// @param skill to train
  function trainCrew(bytes32 entityId, Skill skill) public {
    // Does the caller own the entity?
    if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    // Can the entity be trained?
    if (Training.getTime(entityId) != uint256(0)) revert InvalidState();

    bytes32 skills = Persona.getSkills(entityId);
    uint8 level = getFieldUint8(skills, uint8(skill));
    uint256 time = levelTime(level + 1) + block.timestamp;
    Training.set(entityId, time, skill);
  }

  /// Stop training a skill.  All time invested into training skill is also lost
  /// @param entityId to stop training
  function stopTraining(bytes32 entityId) public {
    // Does the caller own the entity?
    if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();

    Training.deleteRecord(entityId);
  }

  /// Once a crew person has finished training they can be "certified" to the
  /// next level.
  /// @param entityId to level up
  function certifyCrew(bytes32 entityId) public {
    // Does the caller own the entity?
    if (OwnedBy.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();
    (uint256 time, Skill skill) = Training.get(entityId);
    // Check that they ARE training
    if (time != uint256(0)) revert InvalidState();
    // Check that they are DONE training
    if (time < block.timestamp) revert NotReady();

    bytes32 skills = Persona.getSkills(entityId);
    uint8 level = getFieldUint8(skills, uint8(skill)) + 1;
    skills = setFieldUint8(skills, level, uint8(skill));
    Persona.setSkills(entityId, skills);
    Training.deleteRecord(entityId);
  }

  /// Based on our tuning data levels should increase at a speed
  /// @param level base for time
  function levelTime(uint8 level) public pure returns (uint256) {
    return 10 * (level ** 6);
  }
}
