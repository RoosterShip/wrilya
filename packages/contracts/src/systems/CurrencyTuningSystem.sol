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
import {WorldResourceIdLib} from "@latticexyz/world/src/WorldResourceId.sol";
import {ResourceId} from "@latticexyz/store/src/ResourceId.sol";
import "../codegen/index.sol";
import "../codegen/common.sol";
import "../codegen/world/IWorld.sol";
import "../errors.sol";
import "../utils.sol";
import "../checks.sol";
import "../ledger.sol";
import "../constants.sol";
import "../xchg.sol";

// ----------------------------------------------------------------------------
/// @title CurrencyTuningSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract CurrencyTuningSystem is System {
  /**
   * @dev Set the base currency tuning values
   *
   * Requirements:
   *
   * - Only the governor can call the contract
   * - All the currency state is zero
   * - The max supply value passed must be great then zero
   *
   * @param maxSupply_ of tokens that the currency system can have (buy or mint)
   * @param xchgFeeBuy_ fee charged by the currency system for buying tokens
   * @param xchgFeeSell_ feed charged by the currency system for selling tokens
   */
  function currencyTuningSet(
    uint256 maxSupply_,
    uint256 xchgFeeBuy_,
    uint256 xchgFeeSell_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(maxSupply_ > 0, InvalidArgument());
    require(
      (0 == CurrencyTuning.getMaxSupply())
        && (0 == CurrencyTuning.getXchgFeeBuy())
        && (0 == CurrencyTuning.getXchgFeeSell())
        && (0 == CurrencyTuning.getXchgNonce())
        && (0 == CurrencyConfig.getTotalSupply())
        && (0 == CurrencyConfig.getLiquidity())
        && (false == CurrencyConfig.getXchgActive()),
      InvalidState()
    );

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyTuning.setMaxSupply(maxSupply_);
    CurrencyTuning.setXchgFeeBuy(xchgFeeBuy_);
    CurrencyTuning.setXchgFeeSell(xchgFeeSell_);
  }

  /**
   * Set the currency fee for any buy orders
   *
   * Requirements:
   *
   * - Only the governor can set this
   * - The fee should be a percentage
   *
   * @param fee_ percentage fee (ex: 0.05e18 == 5 percent)
   */
  function currencyTuningSetXchgFeeBuy(uint256 fee_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyTuning.setXchgFeeBuy(fee_);
  }

  /**
   * Set the currency fee for any sell orders
   *
   * Requirements:
   *
   * - Only the governor can set this
   * - The fee should be a percentage
   *
   * @param fee_ percentage fee (ex: 0.05e18 == 5 percent)
   */
  function currencyTuningSetXchgFeeSell(uint256 fee_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyTuning.setXchgFeeSell(fee_);
  }

  /**
   * @dev Set the max amount of currency the system can create
   *
   * Requirements:
   *
   * - Only the Governor invoke transaction
   * - The new amount must be gte the current amount of tokens created
   *
   * @param amount_ to set the total supply to
   */
  function currencyTuningSetMaxSupply(uint256 amount_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(amount_ >= CurrencyConfig.getTotalSupply(), InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyTuning.setMaxSupply(amount_);
  }
}
