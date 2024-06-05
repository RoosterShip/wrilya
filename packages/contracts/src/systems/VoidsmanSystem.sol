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

import { 
  newEntityID,
  toBytes32,
  getFieldUint8,
  setFieldUint8,
  isContract,
  notify
} from "../utils.sol";

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
  EntityNameRegistryTable,
  EntityOwnerTable,
  EntityTypeTable,
  GameConfigTable,
  VoidsmanInfoTable,
  VoidsmanInfoTableData,
  VoidsmanPersonaTable,
  VoidsmanRequirementsTable,
  VoidsmanRequirementsTableData,
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
    bytes32 entityId = newEntityID();

    EntityTypeTable.set(entityId, EntityEnum.VOIDSMAN);
    EntityNameRegistryTable.set(nameHash, true);

    // Set Voidsman Info
    VoidsmanPersonaTable.set(entityId, home, name, portrait);
    VoidsmanInfoTable.set(entityId, 0, new uint8[](10), new uint8[](8));

    // Charge a fee for this.
    invoice(owner, GameConfigTable.getVoidsmanCreateCost());

    // Finally assign ownership
    EntityOwnerTable.set(entityId, owner);
    notify(OperationEnum.ENTITY_CREATE, abi.encode(owner, entityId)); 
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
    if (EntityTypeTable.get(entityId) != EntityEnum.VOIDSMAN) revert InvalidArgument();

    // Get the name hash because we will want to free it back up for usage 
    bytes32 nameHash = keccak256(bytes(VoidsmanPersonaTable.getName(entityId)));

    // Delete the entity info
    EntityTypeTable.deleteRecord(entityId);
    EntityNameRegistryTable.deleteRecord(nameHash);

    // Delete the Voidsman info
    VoidsmanTrainingTable.deleteRecord(entityId);
    VoidsmanInfoTable.deleteRecord(entityId);
    VoidsmanPersonaTable.deleteRecord(entityId);

    // Release it from ownership 
    EntityOwnerTable.deleteRecord(entityId);

    notify(OperationEnum.ENTITY_DESTROY, abi.encode(owner, entityId)); 
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

    // Make sure we have a voidsman 
    if (EntityTypeTable.get(entityId) != EntityEnum.VOIDSMAN) revert InvalidArgument();

    // Make sure we are not currently training
    if (VoidsmanTrainingTable.getTime(entityId) != uint256(0)) revert InvalidState();

    VoidsmanInfoTableData memory info = VoidsmanInfoTable.get(entityId);

    // Verify compentency requiremetns
    uint8 nextLevel = info.comps[uint(field)] + 1;
    if(nextLevel > GameConfigTable.getVoidsmanMaxCompetency()) revert InvalidState();
    VoidsmanRequirementsTableData memory req = VoidsmanRequirementsTable.get(nextLevel, field);
    if(req.competencies.length != 0) {
      if(req.competencies[0] > info.comps[0]) revert InvalidState();
      if(req.competencies[1] > info.comps[1]) revert InvalidState();
      if(req.competencies[2] > info.comps[2]) revert InvalidState();
      if(req.competencies[3] > info.comps[3]) revert InvalidState();
      if(req.competencies[4] > info.comps[4]) revert InvalidState();
      if(req.competencies[5] > info.comps[5]) revert InvalidState();
      if(req.competencies[6] > info.comps[6]) revert InvalidState();
      if(req.competencies[7] > info.comps[7]) revert InvalidState();
      if(req.competencies[8] > info.comps[8]) revert InvalidState();
      if(req.competencies[9] > info.comps[9]) revert InvalidState();
    }
    
    // Verify stats requirements
    if(req.stats.length != 0) {
      if(req.stats[0] > info.stats[0]) revert InvalidState();
      if(req.stats[1] > info.stats[1]) revert InvalidState();
      if(req.stats[2] > info.stats[2]) revert InvalidState();
      if(req.stats[3] > info.stats[3]) revert InvalidState();
      if(req.stats[4] > info.stats[4]) revert InvalidState();
      if(req.stats[5] > info.stats[5]) revert InvalidState();
      if(req.stats[6] > info.stats[6]) revert InvalidState();
      if(req.stats[7] > info.stats[7]) revert InvalidState();
    }

    // Check that the XP reg is good
    if(req.xp > info.xp) revert InvalidState();

    // All checks pass.  Start training
    VoidsmanTrainingTable.set(entityId, levelTime(uint256(nextLevel)) + block.timestamp, field);

    // And now let's bill the user
    invoice(owner, levelCost(nextLevel));

    notify(OperationEnum.VOIDSMAN_TRAIN, abi.encode(owner, entityId)); 
  }

  /// Stop training a skill.  All time invested into training skill is also lost
  /// @param entityId to stop training
  function voidsmanTrainCancel(bytes32 entityId) public {
   
    bytes32 owner = toBytes32(_msgSender());

    // Verify Game is Up and Running
    if(!GameConfigTable.getActive()) revert GameInactive();

    // And that the caller owns the entity
    if (EntityOwnerTable.get(entityId) != toBytes32(_msgSender())) revert Unauthorized();

    // Make sure we have a voidsman 
    if (EntityTypeTable.get(entityId) != EntityEnum.VOIDSMAN) revert InvalidArgument();

    // All good to go 
    VoidsmanTrainingTable.deleteRecord(entityId);
   
    notify(OperationEnum.VOIDSMAN_TRAIN_CANCEL, abi.encode(owner, entityId)); 
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
    
    // Make sure we have a voidsman 
    if (EntityTypeTable.get(entityId) != EntityEnum.VOIDSMAN) revert InvalidArgument();

    (uint256 time, FieldEnum field) = VoidsmanTrainingTable.get(entityId);
    // Check that they ARE training
    if (time == uint256(0)) revert InvalidState();
    // Check that they are DONE training
    if (time > block.timestamp) revert NotReady();

    // If we are this far then we are good to update the record.
    // NOTE:  Certification does not cost the player anything
    uint8 level = VoidsmanInfoTable.getItemComps(entityId, uint256(field));
    VoidsmanInfoTable.updateComps(entityId, uint256(field), level + 1);
    VoidsmanTrainingTable.deleteRecord(entityId);
    
    notify(OperationEnum.VOIDSMAN_CERTIFY, abi.encode(owner, entityId)); 
  }

  /// Admin function to set the training requirments for a specific field of a specific
  /// level.  This is to allow for non-algorithmic tuning of "skill tree" requirements
  /// @param level of the field in that the requirements will apply to
  /// @param field for the requirement
  /// @param xp that must be met or exceeded
  /// @param comps uint8 array of length of the FieldEnum
  /// @param stats uint8 array of length of the AbilityEnum
  function voidsmanSetTrainingRequirements(
    uint8 level,
    FieldEnum field,
    uint256 xp,
    uint8[] calldata comps,
    uint8[] calldata stats)
  public {
    // Verify Game is Up and Running
    if(GameConfigTable.getAdmin() != _msgSender() ) revert Unauthorized();

    if(comps.length != 10) revert InvalidArgument();
    if(stats.length != 8) revert InvalidArgument();

    VoidsmanRequirementsTable.set(level, field, xp, comps, stats);
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