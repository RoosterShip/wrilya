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

import {System} from "@latticexyz/world/src/System.sol";
import "../entity.sol";
import "../ledger.sol";
import "../utils.sol";
import {Unauthorized, InvalidState, NotReady} from "../errors.sol";
import {
  EntityInfo,
  GameConfig,
  VMGeneralTuning,
  VMSkillsTuning,
  VMInfo,
  VMLearning,
  VMLearnReq
} from "../codegen/index.sol";
import {Ability, Actor, Knowledge} from "../codegen/common.sol";

// ----------------------------------------------------------------------------
/**
 * @title VoidsmanTuningSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract for Voidsmen
 */
contract VoidsmanTuningSystem is System {
  function voidsmanGeneralTuningSet(
    uint256 mintFee,
    uint256 xpMax,
    uint256 xpBase,
    uint256 xpPower
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    VMGeneralTuning.set(mintFee, xpMax, xpBase, xpPower);
  }

  function voidsmanSkillsTuningSet(
    uint8 trainingFieldMaxValue,
    uint16 trainingieldMaxTotal,
    uint256 trainingCostBase,
    uint256 trainingCostPower,
    uint256 trainingTimeBase,
    uint256 trainingTimePower,
    uint8 abilityFieldMaxValue,
    uint256 abilityPointsBase,
    uint256 abilityPointsPower,
    uint16 abilityRespecMax,
    uint256 abilityRespecCostBase,
    uint256 abilityRespecCostPower
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    VMSkillsTuning.set(
      trainingFieldMaxValue,
      trainingieldMaxTotal,
      trainingCostBase,
      trainingCostPower,
      trainingTimeBase,
      trainingTimePower,
      abilityFieldMaxValue,
      abilityPointsBase,
      abilityPointsPower,
      abilityRespecMax,
      abilityRespecCostBase,
      abilityRespecCostPower
    );
  }

  /**
   * @dev Admin function to set the training requirments for a specific field of
   * a specific
   * level.  This is to allow for non-algorithmic tuning of "skill tree"
   * requirements
   * @param level_ of the field in that the requirements will apply to
   * @param field_ for the requirement
   * @param xp_ that must be met or exceeded
   * @param skills_ bytes32 uint8 bytefield of required skills
   */
  function voidsmanTuningSetLearningRequirement(
    uint8 level_,
    Knowledge field_,
    uint256 xp_,
    bytes32 skills_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMLearnReq.set(level_, field_, xp_, skills_);
  }

  function voidsmanTuningSetMintFee(uint256 fee_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMGeneralTuning.setMintFee(fee_);
  }

  function voidsmanTuningSetTrainingFieldMaxValue(uint8 value_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setTrainingFieldMaxValue(value_);
  }

  function voidsmanTuningSetTrainingFieldsMaxTotal(uint16 value_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setTrainingFieldsMaxTotal(value_);
  }

  function voidsmanTuningSetTraningCostCurve(
    uint256 base_,
    uint256 power_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setTrainingCostBase(base_);
    VMSkillsTuning.setTrainingCostPower(power_);
  }

  function voidsmanTuningSetTraningTimeCurve(
    uint256 base_,
    uint256 power_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setTrainingTimeBase(base_);
    VMSkillsTuning.setTrainingTimePower(power_);
  }

  function voidsmanTuningSetAbilityFieldMaxValue(uint8 value_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setAbilityFieldMaxValue(value_);
  }

  function voidsmanTuningSetAbilityRespecMax(uint16 value_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setAbilityRespecMax(value_);
  }

  function voidsmanTuningSetAbilityPointsCurve(
    uint256 base_,
    uint256 power_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setAbilityPointsBase(base_);
    VMSkillsTuning.setAbilityPointsPower(power_);
  }

  function voidsmanTuningSetAbilityRespecCostCurve(
    uint256 base_,
    uint256 power_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMSkillsTuning.setAbilityRespecCostBase(base_);
    VMSkillsTuning.setAbilityRespecCostPower(power_);
  }

  function voidsmanTuningSetXpMax(uint256 value_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMGeneralTuning.setXpMax(value_);
  }

  function voidsmanTuningSetXpLevelCurve(uint256 base_, uint256 power_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    VMGeneralTuning.setXpBase(base_);
    VMGeneralTuning.setXpPower(power_);
  }
}
