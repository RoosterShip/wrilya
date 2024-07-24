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
import "../codegen/index.sol";
import "../errors.sol";

// ----------------------------------------------------------------------------
/// @title LedgerTuningSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart contract for setting Ledger Tuning Values
contract LedgerTuningSystem is System {
  /**
   * @dev Set all tuning values for the Ledger in one shot
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   * - The base debit can't be bigger then the max debit
   * - The base debit can't be bigger then the max staked
   *
   * @param baseDebit_ size that all players have to start with
   * @param maxDebit_ that any one player can hold
   * @param maxStake_ that any one player can put up
   * @param maxUnstake_ that any one unstaking operation can do
   * @param timeToUnstake_ needed to complete unstaking the currency
   */
  function ledgerTuningSet(
    uint256 baseDebit_,
    uint256 maxDebit_,
    uint256 maxStake_,
    uint256 maxUnstake_,
    uint256 timeToUnstake_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(maxDebit_ >= baseDebit_, InvalidArgument());
    require(maxStake_ >= baseDebit_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setBaseDebit(baseDebit_);
    LedgerTuning.setMaxDebit(maxDebit_);
    LedgerTuning.setMaxStake(maxStake_);
    LedgerTuning.setMaxUnstake(maxUnstake_);
    LedgerTuning.setTimeToUnstake(timeToUnstake_);
  }

  /**
   * @dev Set Standard (base) level of debit all acounts can have
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   * - The base debit can't be bigger then the max debit
   * - The base debit can't be bigger then the max staked
   *
   * @param baseDebit_ size that all players have to start with
   */
  function ledgerTuningSetBaseDebit(uint256 baseDebit_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(LedgerTuning.getMaxDebit() >= baseDebit_, InvalidArgument());
    require(LedgerTuning.getMaxStake() >= baseDebit_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setBaseDebit(baseDebit_);
  }

  /**
   * @dev Set max amount of debit possible per account
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   * - The base debit can't be bigger then the max debit
   *
   * @param maxDebit_ that any one player can hold
   */
  function ledgerTuningSetMaxDebit(uint256 maxDebit_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(maxDebit_ >= LedgerTuning.getBaseDebit(), InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setMaxDebit(maxDebit_);
  }

  /**
   * @dev Set the max amount of tokens a user can "stake"
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   * - The base debit can't be bigger then the max staked
   *
   * @param maxStake_ that any one player can put up
   */
  function ledgerTuningSetMaxStake(uint256 maxStake_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(maxStake_ >= LedgerTuning.getBaseDebit(), InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setMaxStake(maxStake_);
  }

  /**
   * @dev Set the maxium amount that can be unstaked at a time
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param maxUnstake_ that any one unstaking operation can do
   */
  function ledgerTuningSetMaxUnstake(uint256 maxUnstake_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setMaxUnstake(maxUnstake_);
  }

  /**
   * @dev Set the amount of time it takes to unstake currency
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param timeToUnstake_ needed to complete unstaking the currency
   */
  function ledgerTuningSetTimeToUnstake(uint256 timeToUnstake_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    LedgerTuning.setTimeToUnstake(timeToUnstake_);
  }
}
