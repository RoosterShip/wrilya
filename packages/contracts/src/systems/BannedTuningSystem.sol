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
import { Unauthorized } from "../errors.sol";
import { BanTuning, GameConfig } from "../codegen/index.sol";

// ----------------------------------------------------------------------------
/**
 * @title BannedTuningSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract for banning tuning adjustments
 */
contract BannedTuningSystem is System {
  /**
   * @dev Set all the Banned Tuning Variables
   * @param tempTime_ value for how long a temporary ban lasts
   */
  function bannedTuningSet(uint256 tempTime_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    BanTuning.setTempTime(tempTime_);
  }

  /**
   * @dev Set the banned tuning variables
   *
   * PRECONDITIONS:
   *
   * - Only the Governor can set tuning value
   *
   * @param tempTime_ time used for when a GM issue temp ban is placed
   */
  function bannedTuningSetTempTime(uint256 tempTime_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    BanTuning.setTempTime(tempTime_);
  }
}
