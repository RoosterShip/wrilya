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
import { toBytes32, getFieldUint8, setFieldUint8, isContract, notify } from "../utils.sol";
import { 
  Unauthorized,
  InvalidCaller,
  InvalidState,
  NotReady,
  NameInUse,
  GameInactive,
  InvalidArgument
} from "../errors.sol";
import { HomeEnum, FieldEnum, AbilityEnum, EntityEnum, OperationEnum } from "../codegen/common.sol";
import {
  CurrencyTable,
  EntityIdTable,
  EntityInfoTable,
  EntityNameRegistryTable,
  EntityOwnerTable,
  EntityTypeTable,
  EntityXPTable,
  GameConfigTable,
  VoidsmanCompetencyTable,
  VoidsmanRequirementsTable,
  VoidsmanRequirementsTableData,
  VoidsmanStatsTable,
  VoidsmanTrainingTable
} from "../codegen/index.sol";

import { invoice } from "../currency.sol";

// ----------------------------------------------------------------------------
/// @title VoidsmanSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Voidsmen.
contract VoidsmanSystem is System {

  /// Create a new Crew member and assign it to the caller.  This crew member
  /// will have all levels set to 0.
  //
  /// @param name of the new crew member
  /// @param portrait code from the client that this voidsman is using
  /// @param home Enum value for the crew member
  function voidsmanCreate(string calldata name, string calldata portrait, HomeEnum home) public {

    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    //// Verify player name is good!
    bytes32 nameHash = keccak256(bytes(name));
    if(EntityNameRegistryTable.getValue(nameHash)) revert NameInUse();

    address caller = _msgSender();
    bytes32 owner = toBytes32(caller);

    // Set Entity Info
    uint256 entityValue = EntityIdTable.get() + 1;
    bytes32 entityId = toBytes32(entityValue);

    EntityIdTable.set(entityValue);
    EntityOwnerTable.set(entityId, toBytes32(caller));
    EntityTypeTable.set(entityId, EntityEnum.VOIDSMAN);
    EntityInfoTable.set(entityId, home, name, portrait);
    EntityNameRegistryTable.set(nameHash, true);
    EntityXPTable.set(entityId, 0);

    // Set Voidsman Info
    VoidsmanCompetencyTable.set(entityId, new uint8[](10));
    VoidsmanStatsTable.set(entityId, new uint8[](8));

    // Charge a fee for this.
    invoice(owner, GameConfigTable.getVoidsmanCreateCost());

    // Finally assign ownership
    EntityOwnerTable.set(entityId, toBytes32(caller));
    notify(OperationEnum.ENTITY_CREATE, abi.encode(entityId, owner)); 
  }

  /// Delete a crew member from the caller (burn NFT).
  ///
  /// Note: I might change this to actually transfer crew member instead
  /// @param entityId to delete from chain
  function voidsmanDestroy(bytes32 entityId) public {
    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    // And that the caller owns the entity
    if (EntityOwnerTable.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();

    // Setup the Owner
    address caller = _msgSender();
    bytes32 owner = toBytes32(caller);

    // Get the name hash because we will want to free it back up for usage 
    bytes32 nameHash = keccak256(bytes(EntityInfoTable.getName(entityId)));

    // Delete the entity info
    EntityTypeTable.deleteRecord(entityId);
    EntityInfoTable.deleteRecord(entityId);
    EntityNameRegistryTable.deleteRecord(nameHash);
    EntityXPTable.deleteRecord(entityId);

    // Delete the Voidsman info
    VoidsmanTrainingTable.deleteRecord(entityId);
    VoidsmanCompetencyTable.deleteRecord(entityId);
    VoidsmanStatsTable.deleteRecord(entityId);

    // Release it from ownership 
    EntityOwnerTable.deleteRecord(entityId);

    notify(OperationEnum.ENTITY_DESTROY, abi.encode(entityId, owner)); 
  }

  /// Start the training process for a crew member.  You can only have
  /// one skill being trained at any given time.
  /// @param entityId to train
  /// @param field to train
  function voidsmanTrain(bytes32 entityId, FieldEnum field) public {

    bytes32 owner = toBytes32(_msgSender());

    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    // And that the caller owns the entity
    if (EntityOwnerTable.get(entityId) != owner) revert Unauthorized();

    // Make sure we are not currently training
    if (VoidsmanTrainingTable.getTime(entityId) != uint256(0)) revert InvalidState();

    // // Verify this voidsman meets the requirements
    uint8[] memory comps = VoidsmanCompetencyTable.get(entityId);
    uint8 nextLevel = comps[uint(field)] + 1;
    
    if(nextLevel > GameConfigTable.getVoidsmanMaxCompetency()) revert InvalidState();

    // Let's get the cost of doing this upgrade
    uint8[] memory stats = VoidsmanStatsTable.get(entityId);
    VoidsmanRequirementsTableData memory req = VoidsmanRequirementsTable.get(nextLevel, field);

    if(req.competencies.length != 0) {
      if(req.competencies[0] > comps[0]) revert InvalidState();
      if(req.competencies[1] > comps[1]) revert InvalidState();
      if(req.competencies[2] > comps[2]) revert InvalidState();
      if(req.competencies[3] > comps[3]) revert InvalidState();
      if(req.competencies[4] > comps[4]) revert InvalidState();
      if(req.competencies[5] > comps[5]) revert InvalidState();
      if(req.competencies[6] > comps[6]) revert InvalidState();
      if(req.competencies[7] > comps[7]) revert InvalidState();
      if(req.competencies[8] > comps[8]) revert InvalidState();
      if(req.competencies[9] > comps[9]) revert InvalidState();
    }
    
    // Do the same for the stats
    if(req.stats.length != 0) {
      if(req.stats[0] > stats[0]) revert InvalidState();
      if(req.stats[1] > stats[1]) revert InvalidState();
      if(req.stats[2] > stats[2]) revert InvalidState();
      if(req.stats[3] > stats[3]) revert InvalidState();
      if(req.stats[4] > stats[4]) revert InvalidState();
      if(req.stats[5] > stats[5]) revert InvalidState();
      if(req.stats[6] > stats[6]) revert InvalidState();
      if(req.stats[7] > stats[7]) revert InvalidState();
    }

    // Check that the XP reg is good
    if(req.xp > EntityXPTable.get(entityId)) revert InvalidState();

    // // All checks pass.  Start training
    VoidsmanTrainingTable.set(entityId, levelTime(uint256(nextLevel)) + block.timestamp, field);

    // // And now let's bill the user
    invoice(owner, levelCost(nextLevel));

    notify(OperationEnum.VOIDSMAN_TRAIN, abi.encode(entityId, owner)); 
  }

  /// Stop training a skill.  All time invested into training skill is also lost
  /// @param entityId to stop training
  function voidsmanTrainCancel(bytes32 entityId) public {

    bytes32 owner = toBytes32(_msgSender());

    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    // And that the caller owns the entity
    if (EntityOwnerTable.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();

    // All good to go 
    VoidsmanTrainingTable.deleteRecord(entityId);
    
    notify(OperationEnum.VOIDSMAN_TRAIN_CANCEL, abi.encode(entityId, owner)); 
  }

  /// Once a crew person has finished training they can be "certified" to the
  /// next level.
  /// @param entityId to level up
  function voidsmanCertify(bytes32 entityId) public {
    bytes32 owner = toBytes32(_msgSender());

    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    // And that the caller owns the entity
    if (EntityOwnerTable.get(entityId) != owner) revert Unauthorized();


    (uint256 time, FieldEnum field) = VoidsmanTrainingTable.get(entityId);
    // Check that they ARE training
    if (time == uint256(0)) revert InvalidState();
    // Check that they are DONE training
    if (time > block.timestamp) revert NotReady();

    // If we are this far then we are good to update the record.
    // NOTE:  Certification does not cost the player anything
    uint8 level = VoidsmanCompetencyTable.getItem(entityId, uint256(field));
    VoidsmanCompetencyTable.update(entityId, uint256(field), level + 1);
    VoidsmanTrainingTable.deleteRecord(entityId);
    
    notify(OperationEnum.VOIDSMAN_CERTIFY, abi.encode(entityId, owner)); 
  }

  function voidsmanSetTrainingRequirements(
    uint8 level,
    FieldEnum field,
    uint256 xp,
    uint8[] calldata competencies,
    uint8[] calldata stats)
  public {
    // Verify Game is Up and Running
    if(GameConfigTable.getAdmin() != _msgSender() ) revert Unauthorized();

    if(competencies.length != 10) revert InvalidArgument();
    if(stats.length != 8) revert InvalidArgument();

    VoidsmanRequirementsTable.set(level, field, xp, competencies, stats);
  }

  /// Based on our tuning data levels should increase at a speed
  /// @param level base for time
  function levelTime(uint256 level) public view returns (uint256) {
    uint256 vub = GameConfigTable.getVoidsmanUpgradeTimeBase();
    uint256 vup = GameConfigTable.getVoidsmanUpgradeTimePower();
    return vub * (level ** vup);
  }
  
  /// Based on our tuning data levels should increase at a speed
  /// @param level base for time
  function levelCost(uint256 level) public view returns (uint256) {
    uint256 vub = GameConfigTable.getVoidsmanUpgradeCostBase();
    uint256 vup = GameConfigTable.getVoidsmanUpgradeCostPower();
    return vub * (level ** vup);
  }
}