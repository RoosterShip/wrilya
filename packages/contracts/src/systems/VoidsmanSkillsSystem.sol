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
pragma solidity >=0.8.26;

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------

import { System } from "@latticexyz/world/src/System.sol";
import "../entity.sol";
import "../ledger.sol";
import "../utils.sol";
import "../errors.sol";
import { EntityInfo, GameConfig, VMGeneralTuning, VMSkillsTuning, VMInfo, VMLearning, VMLearnReq } from "../codegen/index.sol";
import { Ability, Actor, Knowledge } from "../codegen/common.sol";

// ----------------------------------------------------------------------------
/**
 * @title VoidsmanSkillsSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract for Voidsmen
 */
contract VoidsmanSkillsSystem is System {
  /**
   * @dev Respec an entity. This just sets all of it's abilities to zero
   * so the player can reassign them as the wish.
   * @param entityId_ to respec
   */
  function voidsmanSkillsRespec(bytes32 entityId_) public {
    bytes32 account = toBytes32(_msgSender());
    uint16 respecs = VMInfo.getRs(entityId_);
    bytes32 skills = VMInfo.getSkills(entityId_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());
    require(respecs < VMSkillsTuning.getAbilityRespecMax(), InvalidState());
    require(sumFieldUint8First16(skills) < VMSkillsTuning.getTrainingFieldsMaxTotal(), InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    uint256 cost = powerCurve(
      VMSkillsTuning.getAbilityRespecCostBase(),
      respecs + 1,
      VMSkillsTuning.getAbilityRespecCostPower()
    );
    Ledger.bill(account, cost);

    // Up the Respec counter
    VMInfo.setRs(entityId_, VMInfo.getRs(entityId_) + 1);

    // Set all Skill back to zero
    VMInfo.setSkills(entityId_, clearFieldUint8Last16(VMInfo.getSkills(entityId_)));
  }

  /**
   * @dev Increments an ablity value on the voidsman.
   * NOTE:  This is done one at a time but might be better to do as a batch
   * @param entityId_ to assign the ability
   * @param field_ to increment
   */
  function voidmanSkillUpgrade(bytes32 entityId_, Ability field_) public {
    bytes32 account = toBytes32(_msgSender());
    bytes32 skills = VMInfo.getSkills(entityId_);
    uint8 abilityPoints = uint8(apForLevel(levelForXP(VMInfo.getXp(entityId_))));
    uint8 fieldVal = uint8(field_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(fieldVal < 32, InvalidArgument());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());
    require(sumFieldUint8Last16(skills) < abilityPoints, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    (, skills) = incFieldUint8Last16(skills, fieldVal);
    VMInfo.setSkills(entityId_, skills);
  }

  /**
   * @dev Have a voidsman start to learn the next level of a given field of study
   * PRECONDITIONS:
   * - Game is active
   * - Caller is the owner of the entity
   * - Entity is a voidsman
   * - Entity is not currently learning a different subject
   * - Entity has not maxed out the field of study
   * - Entity has not learned their max number of subjects levels
   * - Owner has the funds to payfor training
   * @param entityId_ to do the learning
   * @param field_ of study to learn
   */
  function voidsmanSkillLearn(bytes32 entityId_, Knowledge field_) public {
    bytes32 account = toBytes32(_msgSender());
    bytes32 skills = VMInfo.getSkills(entityId_);
    uint8 fieldVal = uint8(field_);
    uint8 nextLevel = getFieldUint8(skills, fieldVal) + 1;
    (uint256 reqXP, bytes32 reqSkills) = VMLearnReq.get(nextLevel, field_);
    uint16 intelBonus = getFieldUint8Last16(skills, uint8(Ability.INTELLIGENCE));
    uint8 skillLevel = getFieldUint8(skills, fieldVal);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(fieldVal < 32, InvalidArgument());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());
    require(0 != VMLearning.getTime(entityId_), InvalidState());
    require(skillLevel >= VMSkillsTuning.getTrainingFieldMaxValue(), InvalidState());
    require(sumFieldUint8First16(skills) < (VMSkillsTuning.getTrainingFieldsMaxTotal() + intelBonus), InvalidState());
    for (uint8 idx = 0; idx < 32; idx++) {
      require(skills[idx] >= reqSkills[idx], InvalidState());
    }
    require(VMInfo.getXp(entityId_) >= reqXP, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.bill(account, learnCost(nextLevel));
    VMLearning.set(entityId_, learnTime(uint256(nextLevel)) + block.timestamp, field_);
  }

  /**
   *
   * @param entityId_ voidsman to drop a skill
   * @param field_ the skill to drop
   */
  function voidsmanSkillForget(bytes32 entityId_, Knowledge field_) public {
    bytes32 account = toBytes32(_msgSender());
    uint8 fieldVal = uint8(field_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(fieldVal < 32, InvalidArgument());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());
    require(VMLearning.getTime(entityId_) == uint256(0), InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    (, bytes32 skills) = decFieldUint8(VMInfo.getSkills(entityId_), fieldVal);
    VMInfo.setSkills(entityId_, skills);
  }

  /**
   * @dev Cancel training (or drop out of the class)
   * @param entityId_ to drop out of their current learning
   */
  function voidsmanSkillDropout(bytes32 entityId_) public {
    bytes32 account = toBytes32(_msgSender());
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    VMLearning.deleteRecord(entityId_);
  }

  /**
   * @dev After the required learning time has passed the voidsman can get their
   * certification and move up a level.
   * @param entityId_ to certify
   */
  function voidsmanSkillCertify(bytes32 entityId_) public {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());
    require(EntityInfo.getActorType(entityId_) == Actor.VOIDSMAN, InvalidArgument());

    (uint256 time, Knowledge field) = VMLearning.get(entityId_);
    if (time == uint256(0)) revert InvalidState();
    if (time > block.timestamp) revert NotReady();

    //---------------------------------
    // Logic Block
    //---------------------------------

    // Everything looks good here.  Update the skill
    (, bytes32 skills) = incFieldUint8(VMInfo.getSkills(entityId_), uint8(field));
    VMInfo.setSkills(entityId_, skills);
    VMLearning.deleteRecord(entityId_);
  }

  //---------------------------------------------------------------------------
  // Internal Functions
  //---------------------------------------------------------------------------
  function apForLevel(uint256 level) internal view returns (uint256) {
    return powerCurve(VMSkillsTuning.getAbilityPointsBase(), level, VMSkillsTuning.getAbilityPointsPower());
  }

  function levelForXP(uint256 xp) internal view returns (uint256) {
    return powerCurve(VMGeneralTuning.getXpBase(), xp, VMGeneralTuning.getXpPower());
  }

  function learnCost(uint256 level) internal view returns (uint256) {
    return powerCurve(VMSkillsTuning.getTrainingCostBase(), level, VMSkillsTuning.getTrainingCostPower());
  }

  function learnTime(uint256 level) internal view returns (uint256) {
    return powerCurve(VMSkillsTuning.getTrainingTimeBase(), level, VMSkillsTuning.getTrainingTimePower());
  }
}
